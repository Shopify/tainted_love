# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceTagBuilder < Base
      def replace!
        TaintedLove.proxy_method('ActionView::Helpers::TagHelper::TagBuilder', :content_tag_string) do |return_value, *args|
          return_value.untaint
        end
      end
    end
  end
end
