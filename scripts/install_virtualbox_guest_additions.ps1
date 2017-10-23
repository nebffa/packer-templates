move /Y C:\Users\vagrant\VBoxGuestAdditions.iso C:\Windows\Temp
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\VBoxGuestAdditions.iso -oC:\Windows\Temp\virtualbox"
cmd /c C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher C:\Windows\Temp\virtualbox\cert\vbox-sha1.cer --root C:\Windows\Temp\virtualbox\cert\vbox-sha1.cer
cmd /c C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher C:\Windows\Temp\virtualbox\cert\vbox-sha256.cer --root C:\Windows\Temp\virtualbox\cert\vbox-sha256.cer
cmd /c C:\Windows\Temp\virtualbox\cert\VBoxCertUtil add-trusted-publisher C:\Windows\Temp\virtualbox\cert\vbox-sha256-r3.cer --root C:\Windows\Temp\virtualbox\cert\vbox-sha256-r3.cer
cmd /c C:\Windows\Temp\virtualbox\VBoxWindowsAdditions.exe /S


D:\VBoxWindowsAdditions-amd64.exe /S /extract 


