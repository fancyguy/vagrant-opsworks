module VagrantPlugins
  module OpsWorks
    module EnvHelpers

      def opsworks_enabled?(env)
        config, _ = env[:env].config_loader.load([:home, :root])
        config.opsworks.enabled
      end

      def stack_id(env)
        unless opsworks_enabled?(env)
          nil
        end

        config, _ = env[:env].config_loader.load([:home, :root])
        config.opsworks.stack_id
      end

    end
  end
end
