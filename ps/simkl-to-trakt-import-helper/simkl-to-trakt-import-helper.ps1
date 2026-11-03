$ErrorActionPreference = 'Stop'

$script:ClientId = $null
$AppName = 'simkl-to-trakt-import-helper'
$AppVersion = '1.1'
$ApiBase = 'https://api.simkl.com'
$OutputFolder = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Simkl to Trakt Import Helper Exports'
$StateRoot = Join-Path $env:LOCALAPPDATA 'SimklToTraktImportHelper'
$script:TokenFolder = $null
$script:RefreshFile = $null
$script:ActivitiesFile = $null
$script:StateVersionFile = $null
$script:AccessToken = $null
$script:ExportNotes = New-Object 'System.Collections.Generic.List[string]'
$script:SkippedEpisodes = 0
$script:FallbackCompletedShows = 0
$script:HistoryDataIncluded = $false
$script:ExportStateVersion = '2'

function Initialize-ClientSettings {
    $clientId = Read-Host 'Paste your Simkl AUTH V2 Client ID (public ID only; not a token or secret)'
    $clientId = ([string]$clientId).Trim()
    if (-not $clientId) { throw 'A Simkl Client ID is required. Start the helper again and enter the Client ID from your own Simkl app.' }
    $script:ClientId = $clientId

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $digest = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($script:ClientId)) }
    finally { $sha.Dispose() }
    $appKey = [BitConverter]::ToString($digest).Replace('-', '').Substring(0, 16)
    $script:TokenFolder = Join-Path $StateRoot $appKey
    $script:RefreshFile = Join-Path $script:TokenFolder 'refresh-token.dpapi'
    $script:ActivitiesFile = Join-Path $script:TokenFolder 'activities.json'
    $script:StateVersionFile = Join-Path $script:TokenFolder 'export-state-version.txt'

    New-Item -ItemType Directory -Force -Path $script:TokenFolder | Out-Null
    New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
}

function Get-QueryString {
    param([hashtable]$Values)
    $parts = New-Object 'System.Collections.Generic.List[string]'
    foreach ($key in $Values.Keys) {
        if ($null -ne $Values[$key] -and "$($Values[$key])" -ne '') {
            $parts.Add(([Uri]::EscapeDataString([string]$key)) + '=' + ([Uri]::EscapeDataString([string]$Values[$key])))
        }
    }
    return ($parts -join '&')
}

function Invoke-SimklRequest {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [hashtable]$Query = @{},
        [ValidateSet('GET', 'POST')][string]$Method = 'GET',
        [object]$Body = $null,
        [switch]$NoUserToken
    )

    $allQuery = @{
        client_id = $ClientId
        'app-name' = $AppName
        'app-version' = $AppVersion
    }
    foreach ($key in $Query.Keys) { $allQuery[$key] = $Query[$key] }
    $queryText = Get-QueryString -Values $allQuery
    $uri = $ApiBase + '/' + $Path.TrimStart('/') + '?' + $queryText
    $headers = @{ 'simkl-api-key' = $ClientId; Accept = 'application/json' }
    if (-not $NoUserToken -and $script:AccessToken) {
        $headers.Authorization = 'Bearer ' + $script:AccessToken
    }

    $request = @{
        Uri = $uri
        Method = $Method
        Headers = $headers
        UserAgent = "$AppName/$AppVersion"
        ErrorAction = 'Stop'
    }
    if ($null -ne $Body) {
        $request.ContentType = 'application/json'
        $request.Body = ConvertTo-Json -InputObject $Body -Compress -Depth 30
    }

    try {
        return Invoke-RestMethod @request
    }
    catch {
        $detail = $_.ErrorDetails.Message
        if (-not $detail -and $_.Exception.Response) {
            try {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $detail = $reader.ReadToEnd()
                $reader.Dispose()
            } catch { }
        }
        if ($detail) { throw "Simkl API request failed: $detail" }
        throw "Simkl API request failed: $($_.Exception.Message)"
    }
}

function Save-RefreshToken {
    param([Parameter(Mandatory = $true)][string]$Token)
    New-Item -ItemType Directory -Force -Path $TokenFolder | Out-Null
    $secure = ConvertTo-SecureString -String $Token -AsPlainText -Force
    $encrypted = ConvertFrom-SecureString -SecureString $secure
    [System.IO.File]::WriteAllText($RefreshFile, $encrypted, [System.Text.UTF8Encoding]::new($false))
}

function Get-SavedRefreshToken {
    if (-not (Test-Path -LiteralPath $RefreshFile)) { return $null }
    try {
        $encrypted = [System.IO.File]::ReadAllText($RefreshFile).Trim()
        if (-not $encrypted) { return $null }
        $secure = ConvertTo-SecureString -String $encrypted
        $pointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
        try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($pointer) }
        finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($pointer) }
    }
    catch { return $null }
}

function Set-TokenResponse {
    param([Parameter(Mandatory = $true)]$Response)
    if (-not $Response.access_token) { throw 'Simkl did not return an access token.' }
    $script:AccessToken = [string]$Response.access_token
    if ($Response.refresh_token) { Save-RefreshToken -Token ([string]$Response.refresh_token) }
}

function New-PkcePair {
    $bytes = New-Object byte[] 32
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($bytes) } finally { $rng.Dispose() }
    $verifier = [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try { $digest = $sha.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($verifier)) }
    finally { $sha.Dispose() }
    $challenge = [Convert]::ToBase64String($digest).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    return @{ Verifier = $verifier; Challenge = $challenge }
}

function Get-ErrorName {
    param([string]$Message)
    if (-not $Message) { return '' }
    try {
        $parsed = $Message | ConvertFrom-Json
        if ($parsed.error) { return [string]$parsed.error }
        if ($parsed.message) { return [string]$parsed.message }
    } catch { }
    return $Message
}

function Get-AccessToken {
    $savedRefresh = Get-SavedRefreshToken
    if ($savedRefresh) {
        Write-Host 'Reconnecting to Simkl using the saved Windows-encrypted sign-in...'
        try {
            $response = Invoke-SimklRequest -Path 'oauth2/token' -Method POST -NoUserToken -Body @{
                grant_type = 'refresh_token'
                client_id = $ClientId
                refresh_token = $savedRefresh
            }
            Set-TokenResponse -Response $response
            return
        }
        catch {
            Write-Host 'The saved sign-in could not be refreshed. Starting a new Simkl PIN approval.' -ForegroundColor Yellow
        }
    }

    Write-Host 'Starting Simkl PIN sign-in (read-only access)...'
    $pkce = New-PkcePair
    $device = Invoke-SimklRequest -Path 'oauth2/device' -Method POST -NoUserToken -Body @{
        client_id = $ClientId
        scope = 'media:read'
        code_challenge = $pkce.Challenge
        code_challenge_method = 'S256'
    }
    if (-not $device.device_code -or -not $device.user_code -or -not $device.verification_uri) {
        throw 'Simkl did not return the expected device sign-in details. Keep this window open and ask for help.'
    }

    Write-Host ''
    Write-Host 'A Simkl page should open. If it does not, visit:' -ForegroundColor Cyan
    Write-Host ([string]$device.verification_uri) -ForegroundColor Cyan
    Write-Host 'Enter this code on that page:' -ForegroundColor Cyan
    Write-Host ([string]$device.user_code) -ForegroundColor White
    Write-Host 'Approve read access for Simkl to Trakt Import Helper. The script is waiting here.'
    try { Start-Process ([string]$device.verification_uri) } catch { }

    $interval = 5
    if ($device.interval) { $interval = [Math]::Max(5, [int]$device.interval) }
    $expiresIn = 900
    if ($device.expires_in) { $expiresIn = [int]$device.expires_in }
    $deadline = [DateTimeOffset]::UtcNow.AddSeconds($expiresIn)
    while ([DateTimeOffset]::UtcNow -lt $deadline) {
        Start-Sleep -Seconds $interval
        try {
            $response = Invoke-SimklRequest -Path 'oauth2/token' -Method POST -NoUserToken -Body @{
                grant_type = 'urn:ietf:params:oauth:grant-type:device_code'
                client_id = $ClientId
                device_code = [string]$device.device_code
                code_verifier = $pkce.Verifier
            }
            Set-TokenResponse -Response $response
            return
        }
        catch {
            $errorName = Get-ErrorName -Message $_.Exception.Message
            if ($errorName -match 'authorization_pending') { continue }
            if ($errorName -match 'slow_down') { $interval += 5; continue }
            if ($errorName -match 'expired_token') { throw 'The PIN expired before approval. Close this window and start the helper again for a fresh code.' }
            if ($errorName -match 'authorization_declined|access_denied') { throw 'Simkl access was declined. Start the helper again if you want to approve it.' }
            throw
        }
    }
    throw 'The Simkl PIN expired. Close this window and start the helper again for a fresh code.'
}

function Get-ItemsFromResponse {
    param($Response, [string]$Type)
    if ($null -eq $Response) { return @() }
    $property = $Response.PSObject.Properties[$Type]
    if ($property -and $null -ne $property.Value) { return @($property.Value) }
    return @()
}

function Test-MaxItemsError {
    param([string]$Message)
    return ($Message -match 'max_items|Too many items|Too many episodes')
}

function Get-ItemsCall {
    param([string]$Type, [string]$Status = '', [string]$EpisodeMode = 'yes')
    $path = "sync/all-items/$Type"
    if ($Status) { $path += "/$Status" }
    if ($EpisodeMode -eq 'summary') {
        # The default item shape keeps status, watched dates, and ratings; ids_only strips them.
        $query = @{}
    }
    else {
        $includeMode = if ($EpisodeMode -eq 'original') { 'original' } else { 'yes' }
        $query = @{
            extended = 'full'
            episode_watched_at = 'yes'
            episode_tvdb_id = 'yes'
            include_all_episodes = $includeMode
        }
    }
    return Invoke-SimklRequest -Path $path -Query $query -Method GET
}

function Get-SimklLibrary {
    param($Activities)

    $all = @{}
    $savedActivities = $null
    $savedStateVersion = $null
    if (Test-Path -LiteralPath $script:StateVersionFile) {
        try { $savedStateVersion = [System.IO.File]::ReadAllText($script:StateVersionFile).Trim() } catch { }
    }
    if ($savedStateVersion -eq $script:ExportStateVersion -and (Test-Path -LiteralPath $ActivitiesFile)) {
        try { $savedActivities = Get-Content -LiteralPath $ActivitiesFile -Raw | ConvertFrom-Json }
        catch { throw 'The saved Simkl activity file could not be read. Keep the helper folder and ask for help before deleting anything.' }
    }
    elseif (Test-Path -LiteralPath $ActivitiesFile) {
        Write-Host 'This helper version needs a fresh full-library export. Your saved Simkl sign-in will be kept.' -ForegroundColor Yellow
    }

    if ($savedActivities) {
        if ($savedActivities.all -eq $Activities.all) {
            $script:NoChanges = $true
            return @{ shows = @(); movies = @(); anime = @() }
        }
        $watchChanged = $false
        $ratingsChanged = $false
        foreach ($name in @('tv_shows', 'movies', 'anime')) {
            $old = $savedActivities.$name
            $new = $Activities.$name
            foreach ($status in @('watching', 'plantowatch', 'hold', 'completed', 'dropped', 'notinteresting')) {
                if ($old.$status -ne $new.$status) { $watchChanged = $true }
            }
            if ($old.rated_at -ne $new.rated_at) { $ratingsChanged = $true }
        }

        if ($watchChanged) {
            $script:HistoryDataIncluded = $true
            Write-Host 'Reading Simkl watchlist and history changes...'
            $response = Invoke-SimklRequest -Path 'sync/all-items' -Query @{
                date_from = [string]$savedActivities.all
                extended = 'full'
                episode_watched_at = 'yes'
                episode_tvdb_id = 'yes'
                include_all_episodes = 'yes'
            } -Method GET
            foreach ($type in @('shows', 'movies', 'anime')) { $all[$type] = @(Get-ItemsFromResponse -Response $response -Type $type) }
        }
        else { $all = @{ shows = @(); movies = @(); anime = @() } }

        if ($ratingsChanged) {
            Write-Host 'Reading Simkl rating changes...'
            $ratingResponse = Invoke-SimklRequest -Path 'sync/ratings' -Query @{
                date_from = [string]$savedActivities.all
            } -Method GET
            foreach ($type in @('shows', 'movies', 'anime')) {
                $all[$type] = @(@($all[$type]) + @(Get-ItemsFromResponse -Response $ratingResponse -Type $type))
            }
        }
        if (-not $watchChanged -and -not $ratingsChanged) {
            $script:ExportNotes.Add('Simkl activity changed in an area this importer does not transfer; no history, watchlist or rating changes were found.')
        }
        return $all
    }

    Write-Host 'First export: checking your full Simkl library once...'
    $script:HistoryDataIncluded = $true
    $plan = @(
        @{ Type = 'shows'; Statuses = @('watching', 'plantowatch', 'hold', 'completed', 'dropped') },
        @{ Type = 'movies'; Statuses = @('plantowatch', 'completed', 'dropped') },
        @{ Type = 'anime'; Statuses = @('watching', 'plantowatch', 'hold', 'completed', 'dropped') }
    )
    foreach ($entry in $plan) {
        $type = [string]$entry.Type
        Write-Host "Reading Simkl $type..."
        try {
            $mode = if ($type -eq 'movies') { 'summary' } else { 'yes' }
            $response = Get-ItemsCall -Type $type -EpisodeMode $mode
            $all[$type] = @(Get-ItemsFromResponse -Response $response -Type $type)
            continue
        }
        catch {
            if (-not (Test-MaxItemsError -Message $_.Exception.Message)) { throw }
            $script:ExportNotes.Add("Simkl's $type response was too large as one request; it was split by status.")
            Write-Host 'Large library response; splitting this type into smaller status groups...'
        }

        $collected = New-Object 'System.Collections.Generic.List[object]'
        foreach ($status in $entry.Statuses) {
            try {
                $mode = if ($type -eq 'movies') { 'summary' } else { 'yes' }
                $response = Get-ItemsCall -Type $type -Status $status -EpisodeMode $mode
            }
            catch {
                if ($type -eq 'movies' -or -not (Test-MaxItemsError -Message $_.Exception.Message)) { throw }
                Write-Host "The $type $status episode details are large; retrying with recorded episodes only..." -ForegroundColor Yellow
                try {
                    $response = Get-ItemsCall -Type $type -Status $status -EpisodeMode 'original'
                    $script:ExportNotes.Add("$type/$status used only recorded episode rows because Simkl's complete episode response was too large.")
                }
                catch {
                    if (-not (Test-MaxItemsError -Message $_.Exception.Message)) { throw }
                    Write-Host "The $type $status response is still too large; retrieving item summaries." -ForegroundColor Yellow
                    $response = Get-ItemsCall -Type $type -Status $status -EpisodeMode 'summary'
                    $script:ExportNotes.Add("$type/$status used item summaries; episode-level rows were not available in this export.")
                }
            }
            foreach ($item in (Get-ItemsFromResponse -Response $response -Type $type)) { $collected.Add($item) }
        }
        $all[$type] = @($collected.ToArray())
    }
    return $all
}

function Get-ExternalId {
    param($Ids, [switch]$Episode)
    if ($null -eq $Ids) { return $null }
    $checks = @(
        @{ Name = 'imdb_id'; Keys = @('imdb', 'imdb_id') },
        @{ Name = 'tmdb_id'; Keys = @('tmdb', 'tmdb_id') },
        @{ Name = 'tvdb_id'; Keys = @('tvdb', 'tvdb_id') }
    )
    if ($Episode) { $checks = @($checks[2], $checks[0], $checks[1]) }
    foreach ($check in $checks) {
        foreach ($key in $check.Keys) {
            $property = $Ids.PSObject.Properties[$key]
            if ($property -and $null -ne $property.Value -and "$($property.Value)" -ne '') {
                return @{ Field = $check.Name; Value = [string]$property.Value }
            }
        }
    }
    return $null
}

function Get-WatchedDate {
    param($Date, $Fallback)
    $value = $Date
    if (-not $value) { $value = $Fallback }
    if (-not $value) { return 'unknown' }
    $text = [string]$value
    if ($text -match '^1970-01-01T00:00:01') { return 'unknown' }
    return $text
}

function Add-OrMergeRow {
    param([hashtable]$Index, [System.Collections.Generic.List[object]]$Rows, [string]$Key, [hashtable]$Row)
    if ($Index.ContainsKey($Key)) {
        $existing = $Rows[[int]$Index[$Key]]
        foreach ($field in $Row.Keys) {
            if (-not $existing.ContainsKey($field) -or $null -eq $existing[$field] -or $existing[$field] -eq '') {
                $existing[$field] = $Row[$field]
            }
            elseif ($field -eq 'watched_at' -and $Row[$field] -ne 'unknown') {
                try {
                    if ($existing[$field] -eq 'unknown' -or ([DateTimeOffset]$Row[$field]) -gt ([DateTimeOffset]$existing[$field])) { $existing[$field] = $Row[$field] }
                } catch { }
            }
        }
        return
    }
    $Index[$Key] = $Rows.Count
    $Rows.Add($Row)
}

function Add-RatingAndWatchlistFields {
    param([hashtable]$Row, $Item)
    if ($Item.status -eq 'plantowatch' -and $Item.added_to_watchlist_at) {
        $Row.watchlisted_at = [string]$Item.added_to_watchlist_at
    }
    if ($null -ne $Item.user_rating) {
        $rating = 0
        if ([int]::TryParse([string]$Item.user_rating, [ref]$rating) -and $rating -ge 1 -and $rating -le 10) {
            $Row.rating = $rating
            if ($Item.user_rated_at) { $Row.rated_at = [string]$Item.user_rated_at }
        }
    }
}

function Add-MediaRow {
    param(
        [hashtable]$Index,
        [System.Collections.Generic.List[object]]$Rows,
        $Item,
        $Media,
        [string]$Type,
        [bool]$IncludeWatch
    )
    if ($null -eq $Media) { return }
    $id = Get-ExternalId -Ids $Media.ids
    if (-not $id) { return }
    $row = @{}
    $row[$id.Field] = $id.Value
    $row.type = $Type
    if ($IncludeWatch -and (($Item.status -eq 'completed') -or $Item.last_watched_at -or [int]$Item.watched_episodes_count -gt 0)) {
        $row.watched_at = Get-WatchedDate -Date $Item.last_watched_at -Fallback $null
    }
    Add-RatingAndWatchlistFields -Row $row -Item $Item
    if ($row.Count -le 2) { return }
    $key = "$Type|$($id.Field)|$($id.Value)"
    Add-OrMergeRow -Index $Index -Rows $Rows -Key $key -Row $row
}

function Convert-LibraryToTraktJson {
    param($Library)
    $rows = New-Object 'System.Collections.Generic.List[object]'
    $index = @{}

    foreach ($item in $Library.movies) {
        Add-MediaRow -Index $index -Rows $rows -Item $item -Media $item.movie -Type 'movie' -IncludeWatch $script:HistoryDataIncluded
    }

    foreach ($type in @('shows', 'anime')) {
        foreach ($item in $Library[$type]) {
            $media = $item.show
            if (-not $media) { $media = $item.anime }
            if (-not $media) { continue }
            $isAnimeMovie = ($type -eq 'anime' -and [string]$item.anime_type -eq 'movie')
            if ($isAnimeMovie) {
                Add-MediaRow -Index $index -Rows $rows -Item $item -Media $media -Type 'movie' -IncludeWatch $script:HistoryDataIncluded
                continue
            }

            # A show-level row preserves only its rating and Plan to Watch state.
            Add-MediaRow -Index $index -Rows $rows -Item $item -Media $media -Type 'show' -IncludeWatch $false

            $episodeCount = 0
            foreach ($season in @($item.seasons)) {
                foreach ($episode in @($season.episodes)) {
                    $episodeIds = $episode.ids
                    if (-not $episodeIds -and $episode.tvdb) { $episodeIds = @{ tvdb_id = $episode.tvdb.id } }
                    $episodeId = Get-ExternalId -Ids $episodeIds -Episode
                    if (-not $episodeId) { $script:SkippedEpisodes++; continue }
                    $watchDate = Get-WatchedDate -Date $episode.watched_at -Fallback $item.last_watched_at
                    $row = @{}
                    $row[$episodeId.Field] = $episodeId.Value
                    $row.type = 'episode'
                    $row.watched_at = $watchDate
                    $key = "episode|$($episodeId.Field)|$($episodeId.Value)"
                    Add-OrMergeRow -Index $index -Rows $rows -Key $key -Row $row
                    $episodeCount++
                }
            }

            # If Simkl records a series as completed but supplies no episode rows,
            # preserve the completion at show level rather than silently dropping it.
            if ($script:HistoryDataIncluded -and $episodeCount -eq 0 -and $item.status -eq 'completed') {
                $showId = Get-ExternalId -Ids $media.ids
                if ($showId) {
                    $row = @{}
                    $row[$showId.Field] = $showId.Value
                    $row.type = 'show'
                    $row.watched_at = Get-WatchedDate -Date $item.last_watched_at -Fallback $null
                    $key = "show|$($showId.Field)|$($showId.Value)"
                    Add-OrMergeRow -Index $index -Rows $rows -Key $key -Row $row
                    $script:FallbackCompletedShows++
                }
            }
        }
    }
    return ,$rows
}

function Save-ExportFiles {
    param([System.Collections.Generic.List[object]]$Rows, $Library)
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $jsonPath = $null
    $summaryPath = Join-Path $OutputFolder "import_summary_$stamp.txt"
    if ($Rows.Count -gt 0) {
        $jsonPath = Join-Path $OutputFolder "trakt_import_$stamp.json"
        $json = ConvertTo-Json -InputObject @($Rows.ToArray()) -Depth 30
        [System.IO.File]::WriteAllText($jsonPath, $json, [System.Text.UTF8Encoding]::new($false))
    }

    $movieRows = @($Rows | Where-Object { $_.type -eq 'movie' }).Count
    $showRows = @($Rows | Where-Object { $_.type -eq 'show' }).Count
    $episodeRows = @($Rows | Where-Object { $_.type -eq 'episode' }).Count
    $ratingRows = @($Rows | Where-Object { $null -ne $_.rating }).Count
    $watchlistRows = @($Rows | Where-Object { $null -ne $_.watchlisted_at }).Count
    $summary = @(
        'Simkl to Trakt import summary'
        '============================='
        "Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        $(if ($jsonPath) { "JSON file: $jsonPath" } else { 'JSON file: none (no transferable changes were found)' })
        "Rows total: $($Rows.Count)"
        "Movie rows: $movieRows"
        "Show rows: $showRows"
        "Episode rows: $episodeRows"
        "Rows with ratings: $ratingRows"
        "Rows added to Trakt watchlist: $watchlistRows"
        "Episode records skipped because no Trakt-supported episode ID was available: $script:SkippedEpisodes"
        "Completed shows preserved as a show-level watched row because Simkl supplied no episode rows: $script:FallbackCompletedShows"
        ''
        'Notes:'
        '- Only Simkl Plan to Watch items map to Trakt watchlist rows. Trakt has no matching labels for Simkl Watching, On Hold, or Dropped.'
        '- A repeated upload is handled by Trakt. This helper only creates the JSON file and does not submit it to Trakt.'
    )
    if ($script:ExportNotes.Count -gt 0) {
        $summary += ''
        $summary += 'Large-library handling:'
        foreach ($note in $script:ExportNotes) { $summary += "- $note" }
    }
    [System.IO.File]::WriteAllLines($summaryPath, [string[]]$summary, [System.Text.UTF8Encoding]::new($false))
    return @{ Json = $jsonPath; Summary = $summaryPath }
}

function Save-ActivitiesSnapshot {
    param($Activities)
    New-Item -ItemType Directory -Force -Path $TokenFolder | Out-Null
    $snapshot = ConvertTo-Json -InputObject $Activities -Depth 20
    [System.IO.File]::WriteAllText($ActivitiesFile, $snapshot, [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::WriteAllText($script:StateVersionFile, $script:ExportStateVersion, [System.Text.UTF8Encoding]::new($false))
}

try {
    Write-Host 'Simkl to Trakt Import Helper' -ForegroundColor Cyan
    Write-Host 'This makes a JSON file for you to upload to Trakt. It does not change Trakt.'
    Write-Host ''
    Initialize-ClientSettings
    Get-AccessToken
    Write-Host 'Checking Simkl activity first...' -ForegroundColor Cyan
    $activities = Invoke-SimklRequest -Path 'sync/activities' -Method GET
    Write-Host 'Simkl sign-in is ready. Reading your library now...' -ForegroundColor Green
    $library = Get-SimklLibrary -Activities $activities
    $rows = Convert-LibraryToTraktJson -Library $library
    $files = Save-ExportFiles -Rows $rows -Library $library
    Save-ActivitiesSnapshot -Activities $activities
    Write-Host ''
    if ($script:NoChanges) {
        Write-Host 'Finished. Simkl has no new history, watchlist or rating changes since the previous export.' -ForegroundColor Green
    }
    elseif ($files.Json) {
        Write-Host 'Finished.' -ForegroundColor Green
        Write-Host "JSON import file: $($files.Json)"
        Write-Host 'Upload this file on Trakt. After the first full import, later files contain changes only.'
    }
    else {
        Write-Host 'Finished. There were no transferable rows, so there is no JSON file to upload.' -ForegroundColor Green
    }
    Write-Host "Summary: $($files.Summary)"
    try { Start-Process -FilePath $OutputFolder } catch { }
}
catch {
    Write-Host ''
    Write-Host 'The helper stopped before making a complete import file.' -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host 'No access token was printed. Do not paste any token or sign-in code into chat.' -ForegroundColor Yellow
}
