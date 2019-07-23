# frozen_string_literal: true

module TaintedLove
  module Validator
    class ActionDispatchDiagnostics < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceActionView

        if warning.stack_trace_line[:file]['action_dispatch/middleware/templates/rescues/diagnostics.html.erb']
          return true
        end
      end
    end
  end
end
