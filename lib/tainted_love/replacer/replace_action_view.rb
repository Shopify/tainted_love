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

        TaintedLove.proxy_method('ActionView::Helpers::TagHelper::TagBuilder', :content_tag_string) do |_, *args|
          # if tag name is tainted
          if args[0].tainted?
            return TainterLove.report(:ReplaceActionView, args[0])
          end

          # if tag content is tainted + html_safe
          if args[1].tainted? && args[1].html_safe?
            return TainterLove.report(:ReplaceActionView, args[1])
          end
        end
      end
    end
  end
end
