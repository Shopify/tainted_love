# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActionView < Base
      def should_replace?
        Object.const_defined?('ActionView')
      end

      def replace!
        ActionView::OutputBuffer.class_eval do
          def append=(value)
            if value.tainted? && value.html_safe?
              TaintedLove.report(
                :ReplaceActionView,
                value,
                [:xss],
                'Tainted string is html_safe'
              )
            end

            self << value
          end
        end

        # Untaint the yield of a template
        mod = Module.new do
          def render(*args, &block)
            super(*args) do |*sub_args, &sub_block|
              block.call(*sub_args, &sub_block).untaint
            end
          end
        end

        ActionView::Template.prepend(mod) if Object.const_defined?('ActionView::Template')
      end
    end
  end
end
