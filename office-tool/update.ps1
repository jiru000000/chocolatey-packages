$releases = 'https://github.com/YerongAI/Office-Tool/releases'

function global:au_GetLatest{
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing #1
	
    $regex = 'OTP.zip$'
    $url = $download_page.links | ? href -match $regex | select -First 1 -expand href
    $url = -Join('https://github.com', $url)
    
	$download_page.links | ? href -match 'YerongAI/Office-Tool/releases/tag/([\d.]+)' | select -First 1 -expand href
    $version = $matches[1]
	
    return @{ Version = $version; URL = $url }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
    }
}

update