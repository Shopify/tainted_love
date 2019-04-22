# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceYAML < Base
      def should_replace?
        Object.const_defined?('YAML')
      end

      def replace!
        YAML.instance_eval do
          alias :_tainted_love_original_load :load

          def load(source, *args)
            TaintedLove.report(
              :ReplaceYAML,
              source,
              [:rce],
              'YAML.load using tainted input'
            ) if source.tainted?

            _tainted_love_original_load(source, *args)
          end
        end
      end
    end
  end
end
