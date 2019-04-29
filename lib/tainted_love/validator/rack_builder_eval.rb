# frozen_string_literal: true

module TaintedLove
  module Validator
    class RackBuilderEval < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceKernel

        if warning.stack_trace.lines.first[:file]['rack/builder.rb']
          return true
        end
      end
    end
  end
end
