# Stop-PortProcess PowerShell Script

A simple but powerful PowerShell function to find and kill the process that is blocking a specific TCP port. This is a common utility for developers who frequently encounter "port already in use" errors when running local development servers (e.g., `npm run dev`, `dotnet run`).

## Features

-   **Simple Syntax**: `Stop-PortProcess 3000` is all you need.
-   **Informative Output**: Tells you the name and PID of the process it's terminating.
-   **Safe Dry-Run Mode**: Supports the `-WhatIf` parameter to show you what it *would* do without actually killing any process.
-   **Automated Setup**: Designed to be loaded automatically in your PowerShell profile for everyday use.

## Prerequisites

-   Windows 10 or Windows 11
-   Windows PowerShell 5.1+ or PowerShell 7+

## Installation and Setup

Follow these steps to make the `Stop-PortProcess` command available every time you open PowerShell.

### Step 1: Create a Scripts Folder

It's best practice to keep all your PowerShell scripts in a dedicated folder.

```powershell
# Create a root PowerShell folder in your Documents
New-Item -Path "$HOME\Documents\PowerShell" -ItemType Directory -ErrorAction SilentlyContinue

# Create a Scripts subfolder
New-Item -Path "$HOME\Documents\PowerShell\Scripts" -ItemType Directory -ErrorAction SilentlyContinue
```

### Step 2: Download the Script

Download the `Stop-PortProcess.ps1` file from this repository and save it inside the folder you just created: `C:\Users\YourUsername\Documents\PowerShell\Scripts`.

### Step 3: Set the PowerShell Execution Policy

For security, PowerShell won't run scripts by default. You need to set the execution policy to allow locally created scripts to run. **This is a one-time setup.**

1.  Open PowerShell **as an Administrator**.
2.  Run the following command:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
3.  When prompted, press `Y` and then Enter. You can now close the administrator window.

> **What does this do?** The `RemoteSigned` policy is a safe setting that allows scripts you create on your own machine to run, but requires scripts downloaded from the internet to have a trusted digital signature.

### Step 4: Add the Script to Your PowerShell Profile

Your PowerShell profile is a script that runs every time you open a new PowerShell terminal. By adding our script here, the `Stop-PortProcess` function will always be available.

1.  Open your profile script in Notepad (if the file doesn't exist, this command will create it):
    ```powershell
    if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }
    notepad $PROFILE
    ```

2.  Add the following line to your profile. This is called "dot-sourcing" and it loads the function into your session.

    ```powershell
    # Load custom utility functions
    . "$HOME\Documents\PowerShell\Scripts\Stop-PortProcess.ps1"
    ```

3.  Save the file in Notepad and close it.

### Step 5: Reload and Verify

Close all PowerShell windows and open a new one. Your profile will load, and the command should now be ready.

You can verify it's loaded by running:
```powershell
Get-Command Stop-PortProcess
```
This should return information about the function.

## Usage

Using the command is extremely simple. Just provide the port number you want to free up.

#### Example 1: Kill a Process on Port 3000

```powershell
Stop-PortProcess 3000
```
**Output:**
```
Found process 'node' (PID: 5572) on port 3000. Attempting to terminate...
Successfully terminated process 'node' (PID: 5572).
```

#### Example 2: Safe "Dry Run" with `-WhatIf`

Use the `-WhatIf` parameter to see what would happen without making any changes.

```powershell
Stop-PortProcess 8080 -WhatIf
```
**Output:**
```
Found process 'MyWebApp' (PID: 12345) on port 8080. Attempting to terminate...
What if: Performing the operation "Stop-Process" on target "MyWebApp (12345)".
```

#### Example 3: No Process Found

If the port is already free, the script will let you know.
```powershell
Stop-PortProcess 9999
```
**Output:**
```
No process found listening on port 9999.
```

## License

This project is licensed under the MIT License.
