# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceObject < Base
      def replace!
        mod = Module.new do
          def send(*args, &block)
            if args[0].tainted? && args[1].tainted?
              TaintedLove.report(:ReplaceObject, args.first, [:rce], 'User input in the first 2 arguments of Object#send')
            end

            super(*args, &block)
          end

          def tainted_love_tracking
            @tainted_love_tracking ||= []
          end
        end

        Object.prepend(mod)
      end
    end
  end
end
