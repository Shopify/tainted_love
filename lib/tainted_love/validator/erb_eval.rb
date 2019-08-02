# frozen_string_literal: true

module TaintedLove
  module Validator
    class ErbEval < Base
      def remove?(warning)
        return true if warning.replacer == :ReplaceKernel && warning.tainted_input.include?('_erbout')
      end
    end
  end
end
