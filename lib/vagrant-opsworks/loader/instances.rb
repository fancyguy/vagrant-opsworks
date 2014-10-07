module VagrantPlugins::OpsWorks::Loader
  class Instances

    def initialize(app, env)
      @app   = app
    end

    def call(env)
      @app.call(env)
    end

  end
end
