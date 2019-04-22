# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceKernel < Base
      def replace!
        %i[eval system `].each do |method|
          TaintedLove.proxy_method(Kernel, method) do |_, *args|
            TaintedLove.report(:ReplaceKernel, args.first) if args.first&.tainted?
          end
        end

        Kernel.class_eval do
          alias_method :_tainted_love_original_open, :open

          def open(*args, &block)
            first = args.first
            return_value = _tainted_love_original_open(*args, &block)

            if first.tainted?
              return_value.taint

              if first.is_a?(String) && first[0] == '|'
                TaintedLove.report(:ReplaceKernel, first)
              end
            else
              return_value.untaint
            end

            return_value
          end
        end
      end
    end
  end
end
