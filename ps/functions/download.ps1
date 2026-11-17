
function dl {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Url,

        [switch]$Resume
    )

    $curlArgs = @(
        '-fLJO'
        '--progress-bar'
        '--retry', '5'
        '--retry-all-errors'
        '--retry-delay', '2'
    )

    if ($Resume) {
        $curlArgs += '-C'
        $curlArgs += '-'
    }

    & curl.exe @curlArgs $Url

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Download failed. curl exit code: $LASTEXITCODE"
    }
}
