# frozen_string_literal: true

module TaintedLove
  module Validator
    class ErbEval < Base
      def remove?(warning)
        if Object.const_defined?('Rails') || Object.const_defined?('ERB')
          return true if warning.tainted_input['_erbout']
        end
      end
    end
  end
end
