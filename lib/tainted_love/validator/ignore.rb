# frozen_string_literal: true

module TaintedLove
  module Validator
    class Ignore < Base
      class << self
        attr_accessor :trace_hashes
      end

      self.trace_hashes = []

      def remove?(warning)
        hash = warning.stack_trace.trace_hash

        Ignore.trace_hashes.any? do |s|
          hash.start_with?(s)
        end
      end
    end
  end
end
