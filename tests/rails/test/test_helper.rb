# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module TaintedLoveHelpers
  def assert_report(n = 1, &block)
    require 'minitest/mock'
    mock = Minitest::Mock.new

    n.times do
      mock.expect(:call, nil) do
        true
      end
    end

    TaintedLove.stub(:report, mock, &block)

    mock.verify
  end
end

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    include TaintedLoveHelpers
  end
end

TaintedLove.enable! do |config|
  config.reporter = Class.new {
    def add_warning(warning)
    end
  }.new
end
