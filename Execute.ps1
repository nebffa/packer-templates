Param
(
    [Parameter(Mandatory=$true)]
    [ValidateSet('HyperV', 'VirtualBox')]
    [String]$BuildType,

    [Parameter(Mandatory=$true)]
    [ValidateSet('windows-2016-datacenter', 'windows-10-enterprise')]
    [String]$OperatingSystem
)


$ErrorActionPreference = 'Stop'


berks vendor `
    --berksfile="$PSScriptRoot/cookbooks/packer/Berksfile" `
    'cookbooks/vendor'

if (($BuildType -eq 'HyperV') -or ($BuildType -eq 'VirtualBox'))
{
    New-Item -Type Directory -Path 'bypass_winrm_filecopy' -Force | Out-Null
    Get-ChildItem -Path "$PSScriptRoot\cookbooks" -Filter "*.vhdx" | Remove-Item -Force
    Compress-Archive -Path 'cookbooks' `
        -DestinationPath "./bypass_winrm_filecopy/cookbooks.zip" `
        -Force
    packer build -force "$PSScriptRoot/templates/$($BuildType.ToLower())-$($OperatingSystem.ToLower()).json"
}
