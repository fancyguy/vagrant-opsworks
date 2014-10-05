module VagrantPlugins
  module OpsWorks
    module Stack
      def client
        require 'aws-sdk'
        @client ||= AWS::OpsWorks::Client.new
      end

      def instances(stack_id)
        @instances ||= (
          require_relative 'stack/instance'
          instances = Vagrant::Registry.new
          client.describe_instances(stack_id: stack_id)[:instances].sort_by{|i| i[:hostname]}.each do |i|
            instances.register(i[:hostname]) {
              Instance.new(self, i)
            }
          end
         instances
        )
      end
    end
  end
end
