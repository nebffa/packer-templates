winrm set winrm/config/service/auth @{Basic="false"}
winrm set winrm/config/service @{AllowUnencrypted="false"}
Remove-NetFirewallRule -DisplayName 'WinRM-HTTP'

C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:'A:/Post_Autounattend.xml' /quiet /shutdown
