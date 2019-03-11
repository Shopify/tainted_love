# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceMarshal < Base
      def replace!
        Marshal.singleton_class.prepend(MarshalMod)
      end
    end

    module MarshalMod
      def load(source, proc = nil)
        TaintedLove.report(:ReplaceMarshal, source) if source.tainted?

        super(source, proc)
      end
    end
  end
end
