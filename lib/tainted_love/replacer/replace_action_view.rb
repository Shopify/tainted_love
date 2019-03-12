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
              TaintedLove.report(:ReplaceActionView, value)
            end

            self << value
          end
        end
      end
    end
  end
end
