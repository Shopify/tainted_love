# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceSprokets < Base
      def should_replace?
        Object.const_defined?('Sprockets')
      end

      def replace!
        Sprockets::Rails::Helper.prepend(SprocketsHelperMod)
      end
    end

    module SprocketsHelperMod
      def javascript_include_tag(*sources)
        super(*sources).untaint
      end

      def stylesheet_link_tag(*sources)
        super(*sources).untaint
      end
    end
  end
end
