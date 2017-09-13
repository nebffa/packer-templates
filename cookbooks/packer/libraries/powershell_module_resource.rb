require 'chef'
require_relative 'powershell_module_provider'

class PowershellModule < Chef::Resource::Package
  state_attrs :enabled

  provides :powershell_module, platform: ['windows']

  def initialize(name, run_context = nil)
    super
    @resource_name = :powershell_module
    @allowed_actions.push(:install)
    @allowed_actions.push(:uninstall)
    @action = :install
    provider(PowershellModuleProvider)

    @enabled = nil
  end

  def destination(arg = nil)
    set_or_return(:destination, arg, kind_of: String)
  end

  def enabled(arg = nil)
    set_or_return(
      :enabled,
      arg,
      kind_of: [TrueClass, FalseClass]
    )
  end
end
