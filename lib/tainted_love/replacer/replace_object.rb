# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceObject < Base
      def replace!
        Object.prepend(ObjectMod)
      end
    end

    module ObjectMod
      alias_method :_tainted_love_original_send, :send

      def send(*args, &block)
        if args[0].tainted? && args[1].tainted?
          TaintedLove.report(:ReplaceObject, args.first)
        end

        _tainted_love_original_send(*args, &block)
      end

      def tainted_love_tracking
        @tainted_love_tracking ||= []
      end
    end
  end
end
