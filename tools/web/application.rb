# frozen_string_literal: true

require 'sinatra'
require 'json'

REPORT_PATH = ARGV[0]

unless REPORT_PATH
  puts "usage: ruby application.rb path/to/report.json"
  exit 1
end

unless File.exist?(REPORT_PATH)
  puts "Cannot open report file: #{REPORT_PATH}"
  exit 1
end

helpers do
  def prepare_inputs(warning)
    warning['inputs'].sort_by { |_, v| -v }
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  @warnings = JSON.parse(File.read(REPORT_PATH)).sort_by do |k, v|
    -v['inputs'].map { |_, v| v }.max
  end.to_h

  erb :index
end
