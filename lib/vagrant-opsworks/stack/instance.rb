module VagrantPlugins
  module OpsWorks
    module Stack
      class Instance
        include VagrantPlugins::OpsWorks::Stack

        # @return [String]
        #   hostname of the instance
        attr_reader :hostname

        # @return [String]
        #   operating system of the instance
        attr_reader :os

        def initialize(opsworks, config)
          @opsworks = opsworks
          @hostname = config[:hostname]
          @os = config[:os]
          @layers = config[:layer_ids]
        end

        def roles
          layers.map{|l| l[:shortname]}
        end

        def packages
          layers.map{|l| l[:packages]}.flatten
        end

        def layers
          @opsworks.layers.select{|l|
            @layers.include?(l[:layer_id]) && !@opsworks.ignore_layers.include?(l[:shortname])
          }
        end

        def get_proc
          return Proc.new { |config|
            config.vm.define @hostname do |node|
              node.vm.hostname = "#{@hostname}#{@opsworks.hostname_suffix}"
              select_vmbox(node, @os)

              node.vm.provision :shell, inline: "DEBIAN_FRONTEND=noninteractive apt-get -qq install #{packages.join(' ')}"

              node.vm.provision :chef_solo do |chef|
                roles.each{|role| chef.add_role role }
                chef.json = @opsworks.stack.custom_json
              end
            end
          }
        end

      end
    end
  end
end
