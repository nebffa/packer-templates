Param
(
    [Parameter(Mandatory=$true)]
    [ValidateSet('HyperV', 'VirtualBox', 'Azure', 'Parallels')]
    [String]$BuildType,

    [Parameter(Mandatory=$true)]
    [ValidateSet('windows_2016_datacenter', 'windows_10_enterprise')]
    [String]$OperatingSystem
)


$ErrorActionPreference = 'Stop'


Import-Module Utilities


berks vendor `
    --berksfile="$PSScriptRoot/cookbooks/packer/Berksfile" `
    'cookbooks/vendor'

New-Item "$PSScriptRoot/bypass_winrm_filecopy" -ItemType Directory -ErrorAction SilentlyContinue

Compress-Archive -Path 'cookbooks' `
    -DestinationPath "$PSScriptRoot/bypass_winrm_filecopy/cookbooks.zip" `
    -Force

Push-Location $PSScriptRoot

try 
{
    $templateName = "$($BuildType.ToLower())_$($OperatingSystem.ToLower())"
    if (($BuildType -eq 'HyperV') -or ($BuildType -eq 'VirtualBox') -or ($BuildType -eq 'Parallels'))
    {
        New-Item -Type Directory -Path 'bypass_winrm_filecopy' -Force | Out-Null
        Get-ChildItem -Path "$PSScriptRoot\cookbooks" -Filter "*.vhdx" | Remove-Item -Force
        
        packer build -force -var-file="$PSScriptRoot/templates/$templateName.json" `
            -only="parallels-iso" `
            "$PSScriptRoot/templates/virtualbox-windows.json"
            
            
        Test-LastExitCode

        Write-Output "Adding the freshly created box to Vagrant..."
        vagrant box add (Join-Path $env:IMAGES_DIR "$templateName.box") `
            --name $OperatingSystem.ToLower().Replace('_', '-') --force
    }
    elseif ($BuildType -eq 'Azure')
    {
        #az storage blob upload --container-name packer --name cookbooks.zip --file ./cookbooks.zip --account-name vibratopacker --account-key "dzofr2vDemawYCoXodN+LjH9N7MveO73XvK0Zuuy+TcUekbTjTXJ3qtaOlyaC+L9Mf1JvRhgQzo/q2Xr2LscSQ=="
        packer build -force "$PSScriptRoot/templates/$templateName.json"
    }
}
finally
{
    Pop-Location
}
