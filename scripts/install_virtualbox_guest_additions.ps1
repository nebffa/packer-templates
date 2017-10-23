$ErrorActionPreference = 'Stop'


D:\cert\VBoxCertUtil `
    add-trusted-publisher D:\cert\vbox-sha1.cer `
    --root D:\cert\vbox-sha1.cer
D:\cert\VBoxCertUtil `
    add-trusted-publisher D:\cert\vbox-sha256.cer `
    --root D:\cert\vbox-sha256.cer
D:\cert\VBoxCertUtil `
    add-trusted-publisher D:\cert\vbox-sha256-r3.cer `
    --root D:\cert\vbox-sha256-r3.cer


#D:\VBoxWindowsAdditions.exe /S
# something with start-process to make sure it waits, cause the exe exits immediately
Start-Process D:\VBoxWindowsAdditions-amd64.exe /S /extract 




