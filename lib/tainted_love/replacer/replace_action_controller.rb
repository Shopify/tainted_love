# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActionController < Base
      def should_replace?
        Object.const_defined?('ActionController')
      end

      def replace!
        TaintedLove.proxy_method(ActionController::Instrumentation, :send_file) do |_, *args|
          TaintedLove.report(:ReplaceActionController, args.first) if args.first.tainted?
        end

        TaintedLove.proxy_method(ActionController::Instrumentation, :render) do |_, *args|
          unless args.empty?
            f = args.first

            if f.is_a?(Hash)
              if f.key?(:inline) && f[:inline].tainted?
                TaintedLove.report(:ReplaceActionController, f[:inline])
              end

              if f.key?(:file) && f[:file].tainted?
                TaintedLove.report(:ReplaceActionController, f[:file])
              end
            end

            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActionController, f)
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
