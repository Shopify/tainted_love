# frozen_string_literal: true

Dir[File.dirname(__FILE__) + '/tainted_love/**/*.rb'].each { |f| require f }

module TaintedLove
  class << self
    include TaintedLove::Utils

    attr_reader :configuration

    # Enables TaintedLove. Use a block to configure the TaintedLove::Configuration
    def enable!
      configuration = TaintedLove::Configuration.new

      configuration.logger.info('TaintedLove is enabled')
      configuration.replacers = TaintedLove::Replacer::Base.replacers
      configuration.validators = TaintedLove::Validator::Base.validators
      configuration.reporter = TaintedLove::Reporter::StdoutReporter.new

      # Allows customization of which replacers/validators should be used
      yield configuration if block_given?

      @configuration = configuration

      configuration.replacers.each do |replacer|
        replacer = replacer.new
        replacer.replace! if replacer.should_replace?
      end
    end

    def report(replacer, tainted_input)
      warning = TaintedLove::Warning.new
      warning.tainted_input = tainted_input
      warning.stack_trace = TaintedLove::StackTrace.new(Thread.current.backtrace.drop(3))
      warning.replacer = replacer

      should_remove = @configuration.validators.any? do |validator|
        validator.new.remove?(warning)
      end

      @configuration.reporter.add_warning(warning) unless should_remove
    end
  end
end
