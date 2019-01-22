$ErrorActionPreference = 'Stop'


function Import-CatalogCertificate
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [String]$CatalogFilePath
    )

    $ErrorActionPreference = 'Stop'


    $certificate = Get-PfxCertificate -FilePath $CatalogFilePath
    $certificateData = $certificate.Export("cer")
    $temporaryFile = New-TemporaryFile
    [System.IO.File]::WriteAllBytes($temporaryFile, $certificateData)
    Import-Certificate -FilePath $temporaryFile -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher'
}


# Download Paravirtual drivers from https://launchpad.net/kvm-guest-drivers-windows/+download
Write-Output 'Downloading KVM drivers to get the Paravirtualized Network drivers.'
$downloadPath = Join-Path (Resolve-Path '~/Downloads') 'virtio-win.iso'
(New-Object System.Net.WebClient).DownloadFile(
    'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso', 
    $downloadPath)

Write-Output 'Mounting KVM drivers ISO...'
$mountedVolume = Mount-DiskImage $downloadPath -PassThru | Get-Volume

Write-Output 'Importing/trusting driver certificates...'
Get-ChildItem "$($mountedVolume.DriveLetter):\NetKVM" -Recurse -Filter '*.cat' `
    | ForEach-Object { Import-CatalogCertificate -CatalogFilePath $_.FullName }

Write-Output 'Installing drivers...'
pnputil.exe /add-driver "$($mountedVolume.DriveLetter):\NetKVM\*.inf" /subdirs /install
if (-not @(0, 1630).Contains($LASTEXITCODE))
{
    throw $LASTEXITCODE
}

Dismount-DiskImage -ImagePath $downloadPath
Remove-Item $downloadPath
exit 0
