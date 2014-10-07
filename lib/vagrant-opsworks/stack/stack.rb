module VagrantPlugins
  module OpsWorks
    module Stack
      class Stack
        include VagrantPlugins::OpsWorks::Stack

        # @return [String]
        attr_reader :name

        def initialize(opsworks, config)
          @opsworks = opsworks
          @name = config[:name]
          @custom_json = config[:custom_json]
          @os = config[:default_os]
          @custom_cookbooks = config[:use_custom_cookbooks]
          @configuration_manager = config[:configuration_manager]
          @chef_configuration = config[:chef_configuration]
          @cookbooks_source = config[:custom_cookbooks_source]
        end

        def berks_enabled?
          @chef_configuration[:manage_berkshelf]
        end

        def custom_cookbooks?
          @custom_cookbooks
        end

        def custom_cookbooks
          case @cookbooks_source[:type]
          when 'git'
            {
              :type => 'git',
              :url => @cookbooks_source[:url],
              :ref => @cookbooks_source[:revision]
            }
          end
        end

        def opsworks_cookbooks
          {
            :url => 'git@github.com:aws/opsworks-cookbooks.git',
            :ref => "release-chef-#{@configuration_manager[:version]}"
          }
        end

        # @return [Hash]
        def custom_json
          merge_hash(merge_hash({:deploy => @opsworks.apps}, JSON.parse(@custom_json)), @opsworks.supplimental_json)
        end

        def get_proc
          return Proc.new { |config|
            select_vmbox(config, @os)

            config.vm.provision :shell, inline: File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh')), args: [@opsworks.agent_version, @opsworks.agent_bucket, @opsworks.asset_bucket]

            # Fix ssh agent forwarding for sudo as a non privileged user
            # TODO: incorporate the modified template to prevent $SSH_AUTH_SOCK from being reset
            # TODO: inject this into chef so it can run after the user is created
            config.vm.provision :shell, inline: "DEBIAN_FRONTEND=noninteractive apt-get -qq install acl"
            config.vm.provision :shell, inline: "cat /etc/passwd | awk -F':' '{ print $1 }' | grep deploy && setfacl -m u:deploy:rw $SSH_AUTH_SOCK && setfacl -m u:deploy:x $(dirname $SSH_AUTH_SOCK) || true", run: "always"
          }
        end

        protected

        def merge_hash(old, new)
          new.each_pair{|current_key,new_value|
            old_value = old[current_key]

            old[current_key] = if old_value.is_a?(Hash) && new_value.is_a?(Hash)
                                 merge_hash(old_value, new_value)
                               else
                                 new_value
                               end
          }
          old
        end

      end
    end
  end
end
