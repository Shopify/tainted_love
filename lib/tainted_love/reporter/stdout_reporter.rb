# frozen_string_literal: true

module TaintedLove
  module Reporter
    class StdoutReporter < Base
      def add_warning(warning)
        store_warning(warning)

        puts ''
        puts format_warning(warning)
        puts ''
      end

      def format_warning(warning)
        out = []
        out << "[!] Tainted input found by #{warning.replacer}"
        out << warning.stack_trace.trace_hash

        if warning.tainted_input.size < 100
          out << warning.tainted_input.inspect
        else
          out << warning.tainted_input.inspect[0..100] + '...'
        end

        out << warning.stack_trace.lines.take(5)

        out.join("\n")
      end
    end
  end
end
