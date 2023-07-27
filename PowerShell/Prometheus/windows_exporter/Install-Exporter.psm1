<#
 .Synopsis
  Installs Windows prometheus exporter.

 .Description
  Installs Windows prometheus exporter and adjusts the Windows firewall to allow remote prometheus server to poll the exporter.
  It ships a Config.yaml and WebConfig.yaml providing further configuration as well as TLS and basic Authentication.
  Official exporter project https://github.com/prometheus-community/windows_exporter.
  A windows service called windows_exporter will be setup with startup type "automatic".
  Installation files and config are provisioned to "C:/prometheus/windows_exporter/".
  The exporter itself install to "C:\Program Files\windows_exporter\".
  Example process started by this windows service, which is setup during installation: 
  C:\Program Files\windows_exporter\windows_exporter.exe" --log.format logger:eventlog?name=windows_exporter --telemetry.addr 192.168.10.10:9182 --scrape.timeout-margin=30

 .Parameter DownloadURI
  Link to the Download URI of the Prometheus windows exporter MSI file.

 .Parameter RemoteIP
  The IP address to whitelist in the windows firewall, usually the prometheus server.

 .Example
  # Install Windows Prometheus exporter using all parameters
  Install-Prometheus-Exporter `
  -DownloadURI "https://github.com/prometheus-community/windows_exporter/releases/download/v0.19.0/windows_exporter-0.19.0-amd64.msi" `
  -RemoteIP "10.10.10.10" `
#>

$ConfigDir="C:/prometheus/windows_exporter"

function Create-Dir() {
    Write-Output "Creating Directory $ConfigDir`n"
    New-Item $ConfigDir -ItemType Directory -Force
}

function Prepare-Dir() {
    Write-Output "Copying files to $ConfigDir`n"
    Foreach ($file in Get-Childitem -Path $PSScriptRoot) {
        Copy-Item $file -Destination $ConfigDir
    }
}

function Download-Prometheus-Exporter() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Uri
    )
    Write-Output "`nDownloading MSI file from $Uri and saving to $ConfigDir/windows_exporter.msi`n"
    Invoke-WebRequest -Uri $Uri -OutFile "$ConfigDir/windows_exporter.msi"
}

function Install-Prometheus-Exporter() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$DownloadURI,

        [Parameter(Mandatory)]
        [String]$RemoteIP
    )
    
    Create-Dir
    Prepare-Dir
    Download-Prometheus-Exporter -Uri $DownloadURI

    Write-Output "Finally install Prometheus windows exporter`n"
    # Dirty pipe to "Write-Verbose" to make PS wait for the installer process  until its completed
    & msiexec /i C:\prometheus\windows_exporter\windows_exporter.msi REMOTE_ADDR=$RemoteIP --% EXTRA_FLAGS="--config.file=""C:/prometheus/windows_exporter/Config.yaml"" --web.config.file=""C:/prometheus/windows_exporter/WebConfig.yaml""" | Write-Verbose
    
    Start-Sleep -Seconds 5

    Write-Output "Making sure windows_exporter service is started`n"
    Start-Service -Name "windows_exporter" | Write-Verbose

    Write-Output "Done - Exiting`n"
    Start-Sleep -Seconds 4
}

Export-ModuleMember Install-Prometheus-Exporter
