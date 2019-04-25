# frozen_string_literal: true

module TaintedLove
  module Validator
    class RailtiesYamlLoad < Base
      def remove?(warning)
        line = warning.stack_trace_line

        Object.const_defined?('Rails') &&
          warning.replacer == :ReplaceYAML &&
          line[:file]['rails/application.rb'] &&
          line[:method] == 'config_for'
      end
    end
  end
end
