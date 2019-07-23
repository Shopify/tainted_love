# frozen_string_literal: true

module TaintedLove
  # Replacer will replace methods to report tainted input and taint values from user input coming
  # from librairies.
  module Replacer
    class Base
      # Determines if the replacer can run in the current context. This would usually check Ruby
      # version or gem versions to see which classes and methods to replace.
      def should_replace?
        true
      end

      # List of defined replacers
      #
      # @return [Array<Class>]
      def self.replacers
        replacers = TaintedLove::Replacer.constants.map do |const|
          cls = TaintedLove::Replacer.const_get(const)
          cls if cls.method_defined?(:replace!)
        end.compact

        replacers -= [TaintedLove::Replacer::ReplaceObject]

        [TaintedLove::Replacer::ReplaceObject] + replacers
      end
    end
  end
end
