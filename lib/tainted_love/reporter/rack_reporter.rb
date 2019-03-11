# frozen_string_literal: true

require 'erb'

module TaintedLove::Reporter
  class RackReporter
    def initialize(app)
      @app = app
    end

    def add_warning(warning); end

    def call(_env)
      [200, { 'Content-Type': 'text/html' }, %w[allo]]
    end
  end
end
