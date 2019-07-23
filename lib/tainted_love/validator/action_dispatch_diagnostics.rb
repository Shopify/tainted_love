# frozen_string_literal: true

module TaintedLove
  module Validator
    class ActionDispatchDiagnostics < Base
      FILES = %w(
        action_dispatch/middleware/templates/rescues/routing_error.html.erb
        action_dispatch/middleware/templates/rescues/diagnostics.html.erb
      )
      def remove?(warning)
        return unless warning.replacer == :ReplaceActionView


        FILES.any? do |file|
          warning.stack_trace_line[:file][file]
        end
      end
    end
  end
end
