module VagrantPlugins::OpsWorks::Loader
  class Client

    def initialize(app, opsworks)
      @app      = app
      @opsworks = opsworks
    end

    def call(env)
      return @app.pass(env) unless @opsworks.enabled

      require_relative '../client'
      env[:client] = VagrantPlugins::OpsWorks::Client.new(@opsworks.stack_id)

      @app.pass(env)
    end

  end
end
