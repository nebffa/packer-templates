powershell_script 'install Nuget package provider' do
  code 'Install-PackageProvider -Name NuGet -Force'
  not_if '(Get-PackageProvider -Name Nuget -ListAvailable -ErrorAction SilentlyContinue) -ne $null'
end

%w{xNetworking}.each do |ps_module|
  powershell_script "install #{ps_module} module" do
    code "Install-Module #{ps_module} -Force"
    not_if "(Get-Module #{ps_module} -list) -ne $null"
  end
end

dsc_resource 'WinRM' do
  resource :xFirewall
  property :name, 'WinRM'
  property :displayName, 'Windows Remote Management public access.'
  property :localPort, ['5985']
  property :profile, ['Domain', 'Private', 'Public']
  property :protocol, 'TCP'
end
