# frozen_string_literal: true

module TaintedLove
  module Reporter
    # Reporter that outputs warnings in the console
    class StdoutReporter < Base
      attr_accessor :stack_trace_size, :app_path

      def initialize
        super

        @stack_trace_size = 5
        @app_path = Dir.pwd
      end

      def add_warning(warning)
        puts
        format_warning(warning)
        puts
      end

      def format_warning(warning)
        puts '[!] TaintedLove'
        puts "#{warning.stack_trace.trace_hash[0...8]} #{warning.message} [#{warning.tags.join(', ')}]"

        tainted_input = if warning.tainted_input.size < 100
          warning.tainted_input.inspect
        else
          warning.tainted_input.inspect[0..100] + '...'
        end

        puts 'Tainted input: ' + tainted_input

        warning.stack_trace.lines.take(@stack_trace_size).each do |line|
          puts format_line(line)

          next unless line[:file].start_with?(@app_path)

          File.read(line[:file]).lines.each_with_index.drop([0, line[:line_number] - 2].max).take(3).each do |(code, n)|
            puts "| #{n + 1}\t#{code}"
          end
        end
      end

      def format_line(line)
        line[:file].sub(Dir.pwd, '.') + ':' + line[:line_number].to_s + ' in ' + line[:method]
      end
    end
  end
end
