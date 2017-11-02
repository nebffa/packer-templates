$ErrorActionPreference = 'Stop'


# Windows 10 Autounattend is not respecting '<NetworkLocation>Home</NetworkLocation>'
# http://www.msfn.org/board/topic/99339-found-a-workaround-for-the-network-location-bug/
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private


winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

New-NetFirewallRule -DisplayName 'WinRM-HTTP' -LocalPort 5985 -Protocol TCP -Action Allow -Direction Inbound -Profile Any
$enableArgs = @{
    Force = $true
}
try 
{
    $command = Get-Command Enable-PSRemoting
    if($command.Parameters.Keys -Contains "SkipNetworkProfileCheck") 
    {
        $enableArgs.SkipNetworkProfileCheck=$true
    }
}
catch 
{
    $global:error.RemoveAt(0)
}
Enable-PSRemoting @enableArgs
