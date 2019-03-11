# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActionController < Base
      def should_replace?
        Object.const_defined?('ActionController')
      end

      def replace!
        TaintedLove.proxy_method(ActionController::Instrumentation, :render) do |_, *args|
          unless args.empty?
            f = args.first

            if f.is_a?(Hash) && f.key?(:inline) && f[:inline].tainted?
              TainterLove.report(:ReplaceActionController, f[:inline])
            end

            if f.is_a?(String) && f.tainted?
              TainterLove.report(:ReplaceActionController, f)
            end
          end
        end

        TaintedLove.proxy_method(ActionController::Base, :redirect_to) do |_, *args|
          TaintedLove.report(:ReplaceActionController, args.first) if args.first.tainted?
        end
      end
    end
  end
end
