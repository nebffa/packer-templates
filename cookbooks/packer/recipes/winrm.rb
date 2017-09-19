powershell_script 'Install NuGet package provider.' do
  code 'Install-PackageProvider -Name NuGet -Force'
  not_if '(Get-PackageProvider -Name Nuget -ListAvailable -ErrorAction SilentlyContinue) -ne $null'
end

powershell_script 'Configure WinRM' do
  code 'winrm quickconfig -force -quiet'
end

%w{xNetworking}.each do |ps_module|
  powershell_script "Install #{ps_module} PowerShell Module" do
    code "Install-Module #{ps_module} -Force"
    not_if "(Get-Module #{ps_module} -list) -ne $null"
  end
end

dsc_resource 'WinRM Firewall Rules' do
  resource :xFirewall
  property :name, 'WinRM'
  property :displayName, 'Windows Remote Management public access.'
  property :localPort, ['5985']
  property :profile, ['Domain', 'Private', 'Public']
  property :protocol, 'TCP'
end
