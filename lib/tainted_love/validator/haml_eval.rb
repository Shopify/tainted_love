# frozen_string_literal: true

module TaintedLove
  module Validator
    class HamlEval < Base
      CALLS = [
        ['haml/attribute_compiler.rb', 'static_build'],
        ['haml/parser.rb', 'parse_static_hash'],
        ['haml/util.rb', 'block in unescape_interpolation']
      ]

      def remove?(warning)
        return unless warning.replacer == :ReplaceKernel

        line = warning.stack_trace_line

        return unless line[:file]['gems/haml']

        CALLS.any? do |file, method|
          line[:method] == method && line[:file][file]
        end
      end
    end
  end
end
