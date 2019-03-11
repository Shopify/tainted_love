# frozen_string_literal: true
# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActionView < Base
      def should_replace?
        Object.const_defined?('ActionView')
      end

      def replace!
        ActionView::Helpers.include(ActionViewHelpersMod)

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

    module ActionViewHelpersMod
      def javascript_include_tag(*sources)
        puts 'js tag'
        super(*sources).untaint
      end

      def stylesheet_link_tag(*sources)
        puts 'style tag'
        super(*sources).untaint
      end
    end
  end
end
