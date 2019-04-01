# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceSprokets < Base
      def should_replace?
        Object.const_defined?('Sprockets')
      end

      def replace!
        mod = Module.new do
          def javascript_include_tag(*sources)
            super(*sources).untaint
          end

          def stylesheet_link_tag(*sources)
            super(*sources).untaint
          end
        end

        Sprockets::Rails::Helper.prepend(mod)
      end
    end
  end
end
