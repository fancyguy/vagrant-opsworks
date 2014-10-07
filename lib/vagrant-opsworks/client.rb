module VagrantPlugins::OpsWorks
  class Client
    require_relative 'util/dummy_configuration'
    require_relative 'client/app'
    require_relative 'client/instance'
    require_relative 'client/layer'
    require_relative 'client/stack'

    # @return [String]
    attr_reader :stack_id

    # @paran [String] stack_id the stack id to retrieve metadata about
    def initialize(stack_id)
      @stack_id = stack_id
    end

    # @return [Array<App>]
    def apps
      @apps ||= aws_client.describe_apps(stack_id: @stack_id)[:apps].map{|a| App.new(a)}
    end

    # @return [Array<Instance>]
    def instances
      @instances ||= aws_client.describe_instances(stack_id: @stack_id)[:instances].map{|i| Instance.new(i)}
    end

    # @return [Array<Layer>]
    def layers
      @layers ||= aws_client.describe_layers(stack_id: @stack_id)[:layers].map{|l| Layer.new(l)}
    end

    # @return [Stack]
    def stack
      @stack ||= Stack.new(aws_client.describe_stacks(stack_ids: [@stack_id])[:stacks].first)
    end

    protected

    # @return [AWS::OpsWorks::Client]
    def aws_client
      require 'aws-sdk'
      @client ||= AWS::OpsWorks::Client.new
    end

  end
end
