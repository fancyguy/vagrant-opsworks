module VagrantPlugins
  module OpsWorks
    require_relative 'stack'
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui
      # @return [Pathname]
      attr_accessor :data_directory

      def initialize
        @ui               = ::Vagrant::UI::Colored.new
        @ui.opts[:target] = 'OpsWorks'
      end

    end
  end
end
