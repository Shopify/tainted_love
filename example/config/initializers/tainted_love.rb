# frozen_string_literal: true

if ENV['TAINTED_LOVE']
  TaintedLove.enable! do |config|
    config.logger = Rails.logger
  end
end
