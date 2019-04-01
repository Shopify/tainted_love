# frozen_string_literal: true

require 'set'

module TaintedLove
  module Reporter
    # Base reporter
    class Base
      attr_reader :warnings

      def initialize
        @warnings = Hash.new { |h, k| h[k] = Set.new }
      end

      # Stores a warning by its stack trace hash
      #
      # @param warning [TaintedLove::Warning]
      def store_warning(warning)
        @warnings[warning.stack_trace.trace_hash] << warning
      end

      # Adds a warning to the reporter
      #
      # @param warning [TaintedLove::Warning]
      def add_warning(warning)
        store_warning(warning)
      end
    end
  end
end
