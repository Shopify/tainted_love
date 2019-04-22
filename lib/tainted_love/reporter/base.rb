# frozen_string_literal: true

require 'set'

module TaintedLove
  module Reporter
    # Base reporter
    class Base
      attr_reader :warnings

      def initialize
        @warnings = Hash.new do |h, k|
          h[k] = {
            stack_trace: nil,
            replacer: nil,
            inputs: {},
            tags: [],
            message: nil,
          }
        end
      end

      # Stores a warning by its stack trace hash
      #
      # @param warning [TaintedLove::Warning]
      def store_warning(warning)
        key = warning.stack_trace.trace_hash

        @warnings[key].merge!(
          replacer: warning.replacer,
          stack_trace: warning.stack_trace.lines,
          tags: warning.tags,
          message: warning.message,
        )

        @warnings[key][:inputs][warning.tainted_input] = warning.reported_at
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
