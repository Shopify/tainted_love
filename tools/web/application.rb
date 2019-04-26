# frozen_string_literal: true

require 'sinatra'
require 'json'

REPORT_PATH = ARGV[0]

unless REPORT_PATH
  puts "usage: ruby application.rb path/to/report.json"
  exit(1)
end

unless File.exist?(REPORT_PATH)
  puts "Cannot open report file: #{REPORT_PATH}"
  exit(1)
end

helpers do
  def prepare_inputs(warning)
    warning['inputs'].sort_by { |_, reported_at| -reported_at }
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def render_source(file, line)
    File.read(file).lines.each.with_index.drop(line - 2).take(3).to_a
  end
end

get '/' do
  @report = JSON.parse(File.read(REPORT_PATH))
  @warnings = @report['warnings'].sort_by do |_, code_path|
    -code_path['inputs'].map { |_, reported_at| reported_at }.max
  end.to_h

  erb :index
end
