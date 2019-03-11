# frozen_string_literal: true

module TaintedLove
  # Validator are used to prevent false positives based on user input, stack trace,
  # Ruby version or gem version.
  module Validator
    class Base
      def self.validators
        TaintedLove::Validator.constants.map do |const|
          cls = TaintedLove::Validator.const_get(const)
          cls if cls.method_defined?(:remove?)
        end.compact
      end
    end
  end
end
