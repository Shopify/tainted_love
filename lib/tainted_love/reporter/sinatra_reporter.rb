# frozen_string_literal: true

require 'sinatra/base'

module TaintedLove
  module Reporter
    # Starts a Sinatra web server to show the warnings
    class SinatraReporter < Base
      attr_reader :app, :thread

      def initialize
        @app = App.new(self)
        @thread = Thread.new do
          @app.run!
        end
      end

      class App < Sinatra::Base
        def initialize(reporter)
          @reportrer = reporter

          super
        end

        get '/' do
          'Hello World'
        end
      end
    end
  end
end
