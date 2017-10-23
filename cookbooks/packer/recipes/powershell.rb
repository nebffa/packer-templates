# install the PowerShell module that allows us to bootstrap other modules using DSC
%w{PowerShellModule}.each do |ps_module|
  powershell_script "Install #{ps_module} PowerShell Module" do
    code "Install-Module #{ps_module} -Force"
    not_if "(Get-Module #{ps_module} -list) -ne $null"
  end
end
