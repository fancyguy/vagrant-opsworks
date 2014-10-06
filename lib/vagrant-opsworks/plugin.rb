module VagrantPlugins
  module OpsWorks
    class Plugin < ::Vagrant.plugin('2')
      require_relative 'action'

      name 'OpsWorks'
      description 'A Vagrant plugin to provision a stack configured in Amazon OpsWorks'

      action_hook(:opsworks_setup, :environment_load) do |hook|
        hook.append(VagrantPlugins::OpsWorks::Action.prepare_environment)
      end

      config(:opsworks) do
        Config
      end
    end
  end
end
