module VagrantPlugins::OpsWorks::Loader
  class Instances

    def initialize(app, env)
      @app   = app
    end

    def call(env)
      require 'pp'
      pp 'bar'
      exit

      @app.call(env)
    end

  end
end
