# frozen_string_literal: true

module TaintedLove
  # Replacer will replace methods to report tainted input or taint their return value and also
  # taint values from user input coming from librairies
  module Replacer
    class Base
      # Determines if the replacer can run in the current context. This would
      # usually check Ruby version or gem versions to see which methods to replace.
      def should_replace?
        true
      end

      # List of defined replacers
      def self.replacers
        TaintedLove::Replacer.constants.map do |const|
          cls = TaintedLove::Replacer.const_get(const)
          cls if cls.method_defined?(:replace!)
        end.compact
      end
    end
  end
end
