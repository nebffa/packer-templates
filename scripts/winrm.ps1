New-NetFirewallRule -DisplayName 'WinRM-HTTP' -LocalPort 5985 -Protocol TCP -Action Allow -Direction Inbound -Profile Any
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
