# frozen_string_literal: true

module TaintedLove
  module Reporter
    # Reporter that outputs warnings in the console
    class StdoutReporter < Base
      def add_warning(warning)
        puts ''
        puts format_warning(warning)
        puts ''
      end

      def format_warning(warning)
        out = []
        out << "[!] Tainted input found by #{warning.replacer}"
        out << warning.stack_trace.trace_hash

        out << if warning.tainted_input.size < 100
          warning.tainted_input.inspect
        else
          warning.tainted_input.inspect[0..100] + '...'
        end

        out << warning.stack_trace.lines.take(5)

        out.join("\n")
      end
    end
  end
end
