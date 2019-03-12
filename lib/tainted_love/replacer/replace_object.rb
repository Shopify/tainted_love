# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceObject < Base
      def replace!
        Object.prepend(ObjectMod)
      end

    end

    module ObjectMod
      alias :old_send :send

      def send(*args, &block)
        if args.first.tainted?
          TaintedLove.report(:ReplaceObject, args.first)
        end

        old_send(*args, &block)
      end
    end
  end
end
