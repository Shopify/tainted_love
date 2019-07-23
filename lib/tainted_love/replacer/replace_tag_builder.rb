# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceTagBuilder < Base
      def replace!
        block = lambda do |return_value, *args|
          return_value.untaint
        end

        TaintedLove.proxy_method('ActionView::Helpers::TagHelper::TagBuilder', :content_tag_string, &block)
        TaintedLove.proxy_method('ActionView::Helpers::TagHelper::TagBuilder', :tag_options, &block)
      end
    end
  end
end
