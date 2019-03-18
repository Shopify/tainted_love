# frozen_string_literal: true

module TaintedLove
  module Validator
    class ActionViewObjectSend < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceObject

        if warning.stack_trace.lines.first[:file]['actionview/template.rb']
          return true
        end
      end
    end
  end
end
