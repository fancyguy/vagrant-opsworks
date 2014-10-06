module VagrantPlugins
  module OpsWorks
    module EnvHelpers

      def provisioners(name, env)
        env[:machine].config.vm.provisioners.select { |p| p.name == name }
      end

      def chef_solo?(env)
        provisioners(:chef_solo, env).any?
      end

    end
  end
end
