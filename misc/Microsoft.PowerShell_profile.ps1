# Override default PowerShell and pwsh commands to always use -NoLogo
function powershell { & "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo @args }
function pwsh { & "C:\Program Files\PowerShell\7\pwsh.exe" -NoLogo @args }

function prompt {
    if ($PWD.Path -eq "C:\Users\rishabhkrm") {
        "sonu> "  # Custom prompt for this specific folder
    } else {
        "$PWD> "  # Default prompt showing the current directory
    }
}
