module VagrantPlugins::OpsWorks::Loader
  class Stack

    def initialize(app, opsworks)
      @app = app
      @opsworks = opsworks
    end

    def call(env)
      return @app.pass(env) unless @opsworks.enabled

      VagrantPlugins::OpsWorks::Loader.select_vmbox(env[:config], env[:client].stack.default_os)

      env[:config].vm.provision :shell do |s|
        s.inline = File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh'))
        s.args   = [@opsworks.agent_version, @opsworks.agent_bucket, @opsworks.asset_bucket]
      end

      env[:config].vm.provision :shell do |s|
        s.inline = '[ -n "$SSH_AUTH_SOCK" ] && DEBIAN_FRONTEND=noninteractive apt-get -qq install acl && setfacl -m o:rw $SSH_AUTH_SOCK && setfacl -m o:x $(dirname $SSH_AUTH_SOCK)'
      end

      @app.pass(env)
    end

  end
end
