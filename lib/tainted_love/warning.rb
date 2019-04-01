# frozen_string_literal: true

module TaintedLove
  class Warning
    attr_accessor :stack_trace, :replacer, :tainted_input, :reported_at

    def initialize
      @reported_at = Time.now.to_i
    end

    def ==(other)
      stack_trace == other.stack_trace && tainted_input == other.tainted_input
    end

    def stack_trace_line
      @stack_trace.lines.first
    end

    def to_json
      {
        stack_trace: @stack_trace,
        replacer: @replacer,
        tainted_input: @tainted_input,
        reported_at: @reported_at,
      }.to_json
    end
  end
end
