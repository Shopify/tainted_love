# frozen_string_literal: true

require 'json'

module TaintedLove
  module Reporter
    # Reporter that outputs warnings into a JSON file
    class FileReporter < Base
      attr_reader :file_path

      def initialize(file_path = '/tmp/tainted_love.json')
        super()
        @file_path = file_path
      end

      def add_warning(warning)
        super(warning)

        update_file
      end

      def update_file
        report = {
          'warnings': @warnings,
          'application_path': Dir.pwd
        }

        File.write(@file_path, report.to_json)
      end
    end
  end
end
