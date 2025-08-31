# I have symlinked this to:
# "C:\Users\rishabhkrm\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
# "C:\Users\rishabhkrm\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
# also using pws.cmd and pws7.cmd in PATH to open with -NoLogo

function powershell { & "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo @args }
function pwsh { & "C:\Program Files\PowerShell\7\pwsh.exe" -NoLogo @args }

function prompt {
    if ($PWD.Path -eq "C:\Users\rishabhkrm") {
        "sonu> "  # Custom prompt for this specific folder
    } else {
        "$PWD> "  # Default prompt showing the current directory
    }
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
