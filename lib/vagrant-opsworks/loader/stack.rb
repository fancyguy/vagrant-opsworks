module VagrantPlugins::OpsWorks::Loader
  class Stack

    def initialize(app, env)
      @app   = app
    end

    def call(env)
      VagrantPlugins::OpsWorks::Loader.select_vmbox(env[:config], env[:opsworks].stack.default_os)

      config.vm.provision :shell do |s|
        s.inline = File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh'))
        s.args   = [env[:config].agent_version, env[:config].agent_bucket, env[:config].asset_bucket]
      end

      config.vm.provision :shell do |s|
        s.inline = "DEBIAN_FRONTEND=noninteractive apt-get -qq install acl &&setfacl -m o:rw $SSH_AUTH_SOCK && setfacl -m o:x $(dirname $SSH_AUTH_SOCK)"
      end

      @app.call(env)
    end

  end
end
