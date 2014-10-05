module VagrantPlugins
  module OpsWorks
    class Plugin < Vagrant.plugin('2')
      name 'OpsWorks'
      description 'A Vagrant plugin to provision a stack configured in Amazon OpsWorks'

      config(:opsworks) do
        require_relative 'config'
        Config
      end
    end
  end
end
