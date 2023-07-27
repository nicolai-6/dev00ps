##### Install windows_exporter with custom parameter

$RemoteIP = "10.10.10.10"
$DownloadURI = "https://github.com/prometheus-community/windows_exporter/releases/download/v0.19.0/windows_exporter-0.19.0-amd64.msi"

function Import-Dependencies() {
    Import-Module $PSScriptRoot\Install-Exporter.psm1
}

function Deploy-Exporter() {
    Install-Prometheus-Exporter -DownloadURI $DownloadURI -RemoteIP $RemoteIP
}

# for debugging purposes activate "any key for exit to keep the shell window alive in interactive mode"
function Require-AnyKey() {
    Write-Output "Press any key to exit..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function main() {
    Import-Dependencies
    Deploy-Exporter
    Require-AnyKey
}

# run main
main