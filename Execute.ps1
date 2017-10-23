Param
(
    [Parameter(Mandatory=$true)]
    [ValidateSet('HyperV')]
    [String]$BuildType
)


berks vendor `
    --berksfile="$PSScriptRoot\cookbooks\packer\Berksfile" `
    'cookbooks\vendor'

if ($BuildType -eq 'HyperV')
{
    New-Item -Type Directory -Path 'bypass_winrm_filecopy' -Force | Out-Null
    Get-ChildItem -Path "$PSScriptRoot\cookbooks" -Filter "*.vhdx" | Remove-Item -Force
    Compress-Archive -Path 'cookbooks' `
        -DestinationPath "./bypass_winrm_filecopy/cookbooks.zip" `
        -Force

    $env:IMAGES_DIR = 'D:\Images'
    packer build -force "$PSScriptRoot\templates\hyperv-windows-2016-datacenter.json"
}
