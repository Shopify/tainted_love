# frozen_string_literal: true

module TaintedLove
  module Validator
    class I18nLoad < Base
      def remove?(warning)
        return unless [:ReplaceYAML, :ReplaceKernel].include?(warning.replacer)

        line = warning.stack_trace.lines.first

        if line[:file]['i18n/backend/base.rb'] && line[:method].start_with?('load_')
          return true
        end
      end
    end
  end
end
