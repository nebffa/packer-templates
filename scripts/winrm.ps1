netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow

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

winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
