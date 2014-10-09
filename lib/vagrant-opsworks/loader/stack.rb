module VagrantPlugins::OpsWorks::Loader
  class Stack

    def initialize(app, opsworks)
      @app = app
      @opsworks = opsworks
    end

    def call(config)
puts __LINE__
      require 'pp'
      pp @opsworks
      VagrantPlugins::OpsWorks::Loader.select_vmbox(env[:config], @opsworks.stack.default_os)
puts __LINE__
      env[:config].vm.provision :shell do |s|
        s.inline = File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh'))
        s.args   = [@opsworks.agent_version, @opsworks.agent_bucket, @opsworks.asset_bucket]
      end
puts __LINE__
puts 'foo'
puts __LINE__
      env[:config].vm.provision :shell do |s|
        s.inline = "DEBIAN_FRONTEND=noninteractive apt-get -qq install acl &&setfacl -m o:rw $SSH_AUTH_SOCK && setfacl -m o:x $(dirname $SSH_AUTH_SOCK)"
      end
puts __LINE__
      @app.call(env)
    end

  end
end
