# frozen_string_literal: true

module TaintedLove
  class Warning
    attr_accessor :stack_trace, :replacer, :tainted_input

    def ==(other)
      stack_trace == other.stack_trace && tainted_input == other.tainted_input
    end

    def stack_trace_line
      @stack_trace.lines.first
    end
  end
end
