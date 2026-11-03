$ErrorActionPreference = 'Stop'

try {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $picker = New-Object System.Windows.Forms.OpenFileDialog
    $picker.Title = 'Select the program that should open magnet links and .torrent files'
    $picker.Filter = 'Applications (*.exe)|*.exe'
    $picker.Multiselect = $false
    $picker.CheckFileExists = $true
    $picker.RestoreDirectory = $true

    if ($picker.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        exit 0
    }

    $exePath = [System.IO.Path]::GetFullPath($picker.FileName)
    if ([System.IO.Path]::GetExtension($exePath) -ine '.exe') {
        throw 'Please select an .exe application file.'
    }

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($exePath)
    $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($exePath)
    $displayName = $versionInfo.FileDescription
    if ([string]::IsNullOrWhiteSpace($displayName)) {
        $displayName = $baseName
    }
    $displayName = [System.Text.RegularExpressions.Regex]::Replace($displayName, '[\r\n\t]+', ' ').Trim()

    $token = [System.Text.RegularExpressions.Regex]::Replace($baseName, '[^A-Za-z0-9_]', '_').Trim('_')
    if ([string]::IsNullOrWhiteSpace($token)) {
        $token = 'SelectedApp'
    }
    if ($token -match '^\d') {
        $token = 'App_' + $token
    }

    $registryBase = 'Software\CodexMagnetTorrentAssociation'
    $candidateToken = $token
    $suffix = 2
    while ($true) {
        $existingKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("$registryBase\$candidateToken")
        if ($null -eq $existingKey) {
            break
        }
        $existingKey.Close()
        $candidateToken = $token + '_' + $suffix
        $suffix++
    }
    $token = $candidateToken

    $registeredName = $displayName
    $registeredKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\RegisteredApplications')
    if ($null -ne $registeredKey) {
        $existingNames = $registeredKey.GetValueNames()
        $registeredKey.Close()
    } else {
        $existingNames = @()
    }
    $nameSuffix = 2
    while ($existingNames -contains $registeredName) {
        $registeredName = $displayName + ' (' + $nameSuffix + ')'
        $nameSuffix++
    }

    $magnetProgId = 'CodexMagnetTorrent.' + $token + '.Magnet'
    $torrentProgId = 'CodexMagnetTorrent.' + $token + '.Torrent'
    $capabilitiesPath = $registryBase + '\' + $token + '\Capabilities'
    $command = '"' + $exePath + '" "%1"'
    $icon = '"' + $exePath + '",0'

    function ConvertTo-RegString([string]$value) {
        $value = [System.Text.RegularExpressions.Regex]::Replace($value, '[\r\n]+', ' ')
        $value = $value.Replace('\', '\\').Replace('"', '\"')
        return ('"' + $value + '"')
    }

    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add('Windows Registry Editor Version 5.00')
    $lines.Add('')
    $lines.Add('[HKEY_CURRENT_USER\Software\Classes\magnet]')
    $lines.Add(('@=' + (ConvertTo-RegString 'URL:Magnet URI')))
    $lines.Add('"URL Protocol"=""')
    $lines.Add(('"Content Type"=' + (ConvertTo-RegString 'application/x-magnet')))
    $lines.Add('')
    $lines.Add('[HKEY_CURRENT_USER\Software\Classes\magnet\shell\open\command]')
    $lines.Add(('@=' + (ConvertTo-RegString $command)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $magnetProgId + ']'))
    $lines.Add(('@=' + (ConvertTo-RegString 'URL:Magnet URI')))
    $lines.Add(('"FriendlyTypeName"=' + (ConvertTo-RegString ($displayName + ' Magnet URI'))))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $magnetProgId + '\DefaultIcon]'))
    $lines.Add(('@=' + (ConvertTo-RegString $icon)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $magnetProgId + '\shell\open\command]'))
    $lines.Add(('@=' + (ConvertTo-RegString $command)))
    $lines.Add('')
    $lines.Add('[HKEY_CURRENT_USER\Software\Classes\.torrent]')
    $lines.Add(('@=' + (ConvertTo-RegString $torrentProgId)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $torrentProgId + ']'))
    $lines.Add(('@=' + (ConvertTo-RegString ($displayName + ' Torrent File'))))
    $lines.Add(('"FriendlyTypeName"=' + (ConvertTo-RegString ($displayName + ' Torrent File'))))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $torrentProgId + '\DefaultIcon]'))
    $lines.Add(('@=' + (ConvertTo-RegString $icon)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\Software\Classes\' + $torrentProgId + '\shell\open\command]'))
    $lines.Add(('@=' + (ConvertTo-RegString $command)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\' + $capabilitiesPath + ']'))
    $lines.Add(('"ApplicationName"=' + (ConvertTo-RegString $displayName)))
    $lines.Add(('"ApplicationDescription"=' + (ConvertTo-RegString ('Open magnet links and .torrent files with ' + $displayName + '.'))))
    $lines.Add(('"ApplicationIcon"=' + (ConvertTo-RegString $icon)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\' + $capabilitiesPath + '\FileAssociations]'))
    $lines.Add(('".torrent"=' + (ConvertTo-RegString $torrentProgId)))
    $lines.Add('')
    $lines.Add(('[HKEY_CURRENT_USER\' + $capabilitiesPath + '\URLAssociations]'))
    $lines.Add(('"magnet"=' + (ConvertTo-RegString $magnetProgId)))
    $lines.Add('')
    $lines.Add('[HKEY_CURRENT_USER\Software\RegisteredApplications]')
    $lines.Add(((ConvertTo-RegString $registeredName) + '=' + (ConvertTo-RegString $capabilitiesPath)))

    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Title = 'Save the generated registry file'
    $saveDialog.Filter = 'Registry files (*.reg)|*.reg'
    $saveDialog.DefaultExt = 'reg'
    $saveDialog.AddExtension = $true
    $saveDialog.OverwritePrompt = $true
    $saveDialog.FileName = 'register-magnet-and-torrent.reg'
    $saveDialog.InitialDirectory = $PSScriptRoot

    if ($saveDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        exit 0
    }

    $regContent = [string]::Join("`r`n", $lines.ToArray()) + "`r`n"
    $utf16Le = [System.Text.UnicodeEncoding]::new($false, $true)
    [System.IO.File]::WriteAllText($saveDialog.FileName, $regContent, $utf16Le)

    [System.Windows.Forms.MessageBox]::Show(
        "Saved:`r`n$($saveDialog.FileName)`r`n`r`nNo registry changes have been made yet. Double-click the .reg file to register the app, then choose it for magnet and .torrent in Windows Default apps.",
        'Registry file created',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null
}
catch {
    [System.Windows.Forms.MessageBox]::Show(
        $_.Exception.Message,
        'Could not create registry file',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    ) | Out-Null
    exit 1
}