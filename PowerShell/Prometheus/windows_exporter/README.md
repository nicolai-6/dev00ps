# this is how to setup the prometheus exporter on a Windows target

## RUNBOOK
1.) Copy this folder to the Windows target server </br>
2.) Adjust `telemetry.addr` with real IP value of target server in `Config.yaml`</br>
3.) Adjust `basic_auth_users.basicAUTHdefaultUser` and bcrypted password in `WebConfig.yaml` </br>
4.) Add `server.crt` and `server.key` content in PEM-format </br>
5.) Run `Install.ps1` Script on the target server </br>

### note: 
- On the target server, a folder named `C:\prometheus\windows_exporter` will be setup including the configuration files. </br>
- The windows_exporter itself is installed to `C:\Program Files\windows_exporter` </br>
- A service named `windows_exporter` is created on the target server </br>
- A Windows firewall rule is created to allow the `$Remote-IP` to poll the metrics endpoint of the exporter

### appendix:
- official github project of the prometheus windows exporter: </br>
    https://github.com/prometheus-community/windows_exporter
