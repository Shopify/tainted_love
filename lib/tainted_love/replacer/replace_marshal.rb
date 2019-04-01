# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceMarshal < Base
      def replace!
        mod = Module.new do
          def load(source, proc = nil)
            TaintedLove.report(:ReplaceMarshal, source) if source.tainted?

            super(source, proc)
          end
        end

        Marshal.singleton_class.prepend(mod)
      end
    end
  end
end
