module VagrantPlugins
  module OpsWorks
    class Plugin < ::Vagrant.plugin('2')
      require_relative 'action'

      name 'OpsWorks'
      description 'A Vagrant plugin to provision a stack configured in Amazon OpsWorks'

      class << self
        def provision(hook)
          hook.prepend(VagrantPlugins::OpsWorks::Action.configure_berks)

          hook.before(::Vagrant::Action::Builtin::ConfigValidate, VagrantPlugins::OpsWorks::Action.setup)
        end
      end

      action_hook(:opsworks_setup, :environment_load) do |hook|
        hook.append(VagrantPlugins::OpsWorks::Action.prepare_environment)
      end

      action_hook(:opsworks_provision, :machine_action_up, &method(:provision))
      action_hook(:opsworks_provision, :machine_action_reload, &method(:provision))
      action_hook(:opsworks_provision, :machine_action_provision, &method(:provision))

      config(:opsworks) do
        Config
      end
    end
  end
end
