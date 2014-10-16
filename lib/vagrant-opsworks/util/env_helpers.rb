module VagrantPlugins::OpsWorks::Util
  module EnvHelpers

    def enabled?(env)
      opsworks_config(env).enabled
    end

    def provisioners(name, env)
      env[:machine].config.vm.provisioners.select { |p| p.name == name }
    end

    def chef_solo?(env)
      provisioners(:chef_solo, env).any?
    end

    def stack_id(env)
      opsworks_config(env).stack_id
    end

    def opsworks_config(env)
      config(env).opsworks
    end

    protected

    def config(env)
      if env.has_key?(:env)
        config, _ = env[:env].config_loader.load([:home, :root])
      elsif env.has_key?(:machine)
        config = env[:machine].config
      end
      config
    end

    def environment(env)
      if env.has_key?(:env)
        env[:env]
      elsif env.has_key?(:machine)
        env[:machine].env
      end
    end

  end
end
