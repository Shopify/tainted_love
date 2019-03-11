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
      end
    end
  end
end
