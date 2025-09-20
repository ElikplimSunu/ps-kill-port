function Stop-PortProcess {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [int]$Port
    )

    # Find the TCP connection on the specified port that is in a 'Listen' state
    $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue

    if ($null -eq $connection) {
        Write-Host "No process found listening on port $Port."
        return
    }

    # In case multiple processes are on the same port, loop through them
    foreach ($conn in $connection) {
        $processId = $conn.OwningProcess
        try {
            # Get the process details for a more informative message
            $process = Get-Process -Id $processId -ErrorAction Stop
            
            Write-Host "Found process '$($process.ProcessName)' (PID: $processId) on port $Port. Attempting to terminate..."

            # Stop the process. The -Force switch is similar to /F in taskkill
            # The SupportsShouldProcess attribute on CmdletBinding enables -WhatIf and -Confirm
            Stop-Process -Id $processId -Force
            
            if ($?) { # $? is a special variable that is $true if the last command succeeded
                Write-Host "Successfully terminated process '$($process.ProcessName)' (PID: $processId)." -ForegroundColor Green
            }

        }
        catch {
            Write-Warning "Could not stop process with PID $processId. It may have already been terminated. Error: $_"
        }
    }
}