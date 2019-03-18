# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceObject < Base
      def replace!
        Object.prepend(ObjectMod)
      end
    end

    module ObjectMod
      alias :_tainted_love_original_send :send

      def send(*args, &block)
        if args[0].tainted? && args[1].tainted?
          TaintedLove.report(:ReplaceObject, args.first)
        end

        _tainted_love_original_send(*args, &block)
      end
    end
  end
end
