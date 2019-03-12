# frozen_string_literal: true

module TaintedLove
  module Validator
    class SproketsMarshal < Base
      def remove?(warning)
        calling = warning.stack_trace.lines.first

        if calling[:method] == "unmarshaled_deflated" && calling[:file][/sprockets/]
          return true
        end
      end
    end
  end
end
