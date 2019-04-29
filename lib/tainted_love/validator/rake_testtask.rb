# frozen_string_literal: true

module TaintedLove
  module Validator
    class RakeTestTask < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceKernel

        warning.stack_trace.lines.take(5).each do |line|
          return true if line[:file]['rake/testtask.rb']
        end
      end
    end
  end
end
