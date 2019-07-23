# frozen_string_literal: true

module TaintedLove
  module Validator
    class ActiveRecordFind < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceActiveRecord

        warning.stack_trace.lines.take(2).any? do |line|
          line[:file]['lib/active_record/core.rb'] && line[:method] == "find"
        end
      end
    end
  end
end
