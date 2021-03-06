module VagrantPlugins
  module OpsWorks
    require_relative 'custom_json'

    class Config < ::Vagrant.plugin('2', :config)
      # @return [Boolean]
      #   disable use of OpsWorks in Vagrant
      attr_accessor :enabled

      # @return [Boolean]
      #   disable use of OpsWorks Cache
      attr_accessor :cache

      # @return [String]
      #   OpsWorks agent version
      attr_accessor :agent_version

      # @return [String]
      #   OpsWorks agent bucket
      attr_accessor :agent_bucket

      # @return [String]
      #   OpsWorks asset bucket
      attr_accessor :asset_bucket

      # @return [String]
      #   OpsWorks stack id
      attr_accessor :stack_id

      # @return [String]
      #   OpsWorks hostname suffix
      attr_accessor :hostname_suffix

      # @return [Array]
      #   Applications to ignore in OpsWorks stack
      attr_accessor :ignore_apps

      # @return [Array]
      #   Instances to ignore in OpsWorks stack
      attr_accessor :ignore_instances

      # @return [Array]
      #   Layers to ignore in OpsWorks stack
      attr_accessor :ignore_layers

      # @return [Array]
      #   Recipes to ignore in OpsWorks stack
      attr_accessor :ignore_recipes

      # @return [Hash]
      attr_accessor :supplimental_json

      # @return [Hash]
      attr_accessor :custom_cookbooks_source

      def initialize
        super

        @agent_version     = UNSET_VALUE
        @agent_bucket      = UNSET_VALUE
        @asset_bucket      = UNSET_VALUE
        @cache             = UNSET_VALUE
        @enabled           = UNSET_VALUE
        @stack_id          = UNSET_VALUE
        @hostname_suffix   = UNSET_VALUE
        @ignore_apps       = UNSET_VALUE
        @ignore_instances  = UNSET_VALUE
        @ignore_layers     = UNSET_VALUE
        @ignore_recipes    = UNSET_VALUE
        @supplimental_json = UNSET_VALUE
      end

      def finalize!
        @agent_version     = "328"                                       if @agent_version     == UNSET_VALUE
        @agent_bucket      = "opsworks-instance-agent.s3.amazonaws.com"  if @agent_bucket      == UNSET_VALUE
        @asset_bucket      = "opsworks-instance-assets.s3.amazonaws.com" if @asset_bucket      == UNSET_VALUE
        @cache             = true                                        if @cache             == UNSET_VALUE
        @enabled           = @stack_id == UNSET_VALUE ? false : true     if @enabled           == UNSET_VALUE
        @hostname_suffix   = '.vm'                                       if @hostname_suffix   == UNSET_VALUE
        @ignore_apps       = Array.new                                   if @ignore_apps       == UNSET_VALUE
        @ignore_instances  = Array.new                                   if @ignore_instances  == UNSET_VALUE
        @ignore_layers     = Array.new                                   if @ignore_layers     == UNSET_VALUE
        @ignore_recipes    = Array.new                                   if @ignore_recipes    == UNSET_VALUE

        default_json       = VagrantPlugins::OpsWorks::CustomJson.new({
                                          :opsworks => {
                                            :agent_version => @agent_version,
                                            :ruby_version => '2.0.0',
                                            :ruby_stack => 'ruby',
                                            :stack => {
                                              :rds_instances => [{:engine => 'mysql'}]
                                            }
                                          },
                                          :ssh_users => {
                                            Process.uid => {
                                              :name => Etc.getlogin,
                                              :public_key => File.exists?(File.expand_path('~/.ssh/id_rsa.pub')) ? File.read(File.expand_path('~/.ssh/id_rsa.pub')) : nil,
                                              :sudoer => true
                                            },
                                          },
                                          :sudoers => [{:name => 'vagrant'}]
                                        })

        @supplimental_json = default_json if @supplimental_json == UNSET_VALUE
        @supplimental_json = default_json.deep_merge(@supplimental_json) unless @supplimental_json == UNSET_VALUE
      end

      # TODO: implement proper merge handling
      # def merge(other)
      #   super.tap do |result|
      #     result.ignore_apps       = Array.new if other.ignore_apps.nil?
      #     result.ignore_instances  = Array.new if other.ignore_instances.nil?
      #     result.ignore_layers     = Array.new if other.ignore_layers.nil?
      #     result.ignore_recipes    = Array.new if other.ignore_recipes.nil?
      #     result.stack_id          = @stack_id                                               unless other.stack_id == UNSET_VALUE
      #     result.ignore_instances  = @ignore_instances.concat(other.ignore_instances)        if other.ignore_instances.is_a?(Array) && @ignore_instances  != UNSET_VALUE
      #     result.ignore_layers     = @ignore_layers.concat(other.ignore_layers)              if other.ignore_layers.is_a?(Array)    && @ignore_layers     != UNSET_VALUE
      #     result.ignore_recipes    = @ignore_recipes.concat(other.ignore_recipes)            if other.ignore_recipes.is_a?(Array)   && @ignore_recipes    != UNSET_VALUE
      #     result.supplimental_json = merge_hash(@supplimental_json, other.supplimental_json) if other.supplimental_json.is_a?(Hash) && @supplimental_json != UNSET_VALUE
      #   end
      # end

      def validate(machine)
        errors = Array.new
        unless [TrueClass, FalseClass].include?(enabled.class)
          errors << I18n.t('vagrant_opsworks.config.not_a_bool', {
            :config_key => 'opsworks.enabled'
          })
        end

        unless [TrueClass, FalseClass].include?(cache.class)
          errors << I18n.t('vagrant_opsworks.config.not_a_bool', {
            :config_key => 'opsworks.cache'
          })
        end

        {'opsworks configuration' => errors}
      end

    end
  end
end
