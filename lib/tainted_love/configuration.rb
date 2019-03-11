# frozen_string_literal: true

require 'logger'

module TaintedLove
  class Configuration
    attr_accessor :reporter, :logger, :validators, :replacers

    def initialize
      @reporter = TaintedLove::Reporter::StdoutReporter.new
      @logger = Logger.new(STDERR)
      @validators = []
      @replacers = []
    end
  end
end
