# frozen_string_literal: true

require 'json'

module TaintedLove
  module Reporter
    # Reporter that outputs warnings into a JSON file
    class FileReporter < Base
      attr_reader :file_path

      def initialize
        super

        @file_path = '/tmp/tainted_love.json'
      end

      def add_warning(warning)
        super(warning)

        update_file
      end

      def update_file
        File.write(@file_path, @warnings.to_json)
      end
    end
  end
end
