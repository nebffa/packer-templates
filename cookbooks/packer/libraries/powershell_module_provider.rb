require_relative 'powershell_module_resource'
require 'chef'
require 'chef/mixin/powershell_out'

class PowershellModuleProvider < Chef::Provider::LWRPBase
  include Chef::Mixin::PowershellOut

  use_inline_resources

  def whyrun_supported?
    true
  end

  def initialize(powershell_module, run_context)
    super(powershell_module, run_context)
    @powershell_module = powershell_module
  end

  action :install do
    raise ArgumentError, "Required attribute 'package_name' for module installation" unless @new_resource.package_name

    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      install_module
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' installation completed successfully")
    end
  end

  action :uninstall do
    raise ArgumentError, "Required attribute 'package_name' for module uninstallation" unless @new_resource.package_name
    converge_by("Powershell Module '#{@powershell_module.package_name}'") do
      uninstall_module
      Chef::Log.info("Powershell Module '#{@powershell_module.package_name}' uninstallation completed successfully")
    end
  end

  def load_current_resource
    @current_resource = PowershellModule.new(@new_resource.name)

    result = powershell_out("(Get-Module #{@powershell_module.package_name} -ListAvailable) -ne $null")
    result.stdout.chop == 'True' ? @current_resource.enabled(true) : @current_resource.enabled(false)
  end

  private

  def install_module
    powershell_out("Install-Module #{@powershell_module.package_name}")
  end

  def uninstall_module
    powershell_out("Uninstall-Module #{@powershell_module.package_name}")
  end
end
