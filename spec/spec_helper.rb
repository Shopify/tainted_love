# frozen_string_literal: true

require 'bundler/setup'
require 'tainted_love'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
end

class TestReporter
  def add_warning(warning); end

  def self.instance
    @instance ||= TestReporter.new
  end
end

TaintedLove.enable! do |config|
  config.reporter = TestReporter.instance
end
