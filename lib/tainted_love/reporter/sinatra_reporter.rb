# frozen_string_literal: true

require 'sinatra/base'
require 'json'

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
          @reporter = reporter

          super
        end

        get '/' do
          'Hello World'
        end

        get '/warnings.json' do
          content_type :json

          output = @reporter.warnings.values

          if params[:since]
            since = params[:since].to_i

            output.keep_if do |warning|
              warning.reported_at >= since
            end
          end

          output.to_json
        end
      end
    end
  end
end
