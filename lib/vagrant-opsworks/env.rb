module VagrantPlugins
  module OpsWorks
    require_relative 'stack'
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui
      # @return [VagrantPlugins::OpsWorks::Config]
      attr_accessor :config
      # @return [Pathname]
      attr_accessor :data_directory

      def initialize
        @ui               = ::Vagrant::UI::Colored.new
        @ui.opts[:target] = 'OpsWorks'
        @logger = Log4r::Logger.new("vagrantplugins::opsworks::env")
      end

      # @return [Boolean]
      def enabled?
        begin
          config.enabled
        rescue
          false
        end
      end

      # @return [Boolean]
      def cache_enabled?
        begin
          config.cache
        rescue
          false
        end
      end

      # @return [Pathname]
      def cache_directory
        @data_directory.join('cache') if cache_enabled?
      end

      # @return [String]
      def agent_version
        config.agent_version unless config.nil?
      end

      # @return [String]
      def agent_bucket
        config.agent_bucket unless config.nil?
      end

      # @return [String]
      def asset_bucket
        config.asset_bucket unless config.nil?
      end

      # @return [String]
      def stack_id
        config.stack_id unless config.nil?
      end

      # @return [String]
      def hostname_suffix
        config.hostname_suffix unless config.nil?
      end

      # @return [Array]
      def ignore_instances
        config.ignore_instances unless config.nil?
      end

      # @return [Array]
      def ignore_layers
        config.ignore_layers unless config.nil?
      end

      # @return [Array]
      def ignore_recipes
        config.ignore_recipes unless config.nil?
      end

      # @return [Array]
      def supplimental_json
        config.supplimental_json unless config.nil?
      end

      # @return [VagrantPlugins::OpsWorks::Stack::Stack]
      def stack
        if stack_id
          VagrantPlugins::OpsWorks::Stack::Stack.new(self, client.stack)
        end
      end

      # @return [Vagrant::Registry]
      def instances
        if stack_id
          instances = Vagrant::Registry.new
          client.instances.sort_by{|i| i[:hostname]}.each do |i|
            unless ignore_instances.include?(i[:hostname])
              instances.register(i[:hostname]) {
                VagrantPlugins::OpsWorks::Stack::Instance.new(self, i)
              }
            end
          end
          instances
        end
      end

      # @return [Vagrant::Registry]
      def layers
        client.layers
      end

      protected

      # @return [VagrantPlugins::OpsWorks::Client]
      def client
        require_relative 'client'
        @client ||= Client.new(stack_id, cache_directory)
      end
    end
  end
end
