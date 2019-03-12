# frozen_string_literal: true

require 'set'

module TaintedLove
  module Reporter
    class Base
      attr_reader :warnings

      def initialize
        @warnings = Hash.new { |h, k| h[k] = Set.new }
      end

      def store_warning(warning)
        @warnings[warning.stack_trace.trace_hash] << warning
      end
    end
  end
end
