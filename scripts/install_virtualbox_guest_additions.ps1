$ErrorActionPreference = 'Stop'


E:\cert\VBoxCertUtil.exe `
    add-trusted-publisher E:\cert\vbox-sha1.cer `
    --root E:\cert\vbox-sha1.cer
E:\cert\VBoxCertUtil.exe `
    add-trusted-publisher E:\cert\vbox-sha256.cer `
    --root E:\cert\vbox-sha256.cer
E:\cert\VBoxCertUtil.exe `
    add-trusted-publisher E:\cert\vbox-sha256-r3.cer `
    --root E:\cert\vbox-sha256-r3.cer

Start-Process `
    -FilePath E:\VBoxWindowsAdditions-amd64.exe `
    -ArgumentList '/S' `
    -Wait `
    -NoNewWindow

if ($LASTEXITCODE -ne 0)
{
    throw $LASTEXITCODE
}
