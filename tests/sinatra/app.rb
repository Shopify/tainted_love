require 'sinatra'
require 'tainted_love'
require 'erubis'

set :erb, :escape_html => true


get '/' do
  'asdf'
end

get '/eval/:cmd' do |cmd|
  eval(cmd)
end

get '/eval' do
  eval(params[:cmd])
end

get '/xss' do
  erb :xss
end


TaintedLove.enable! do |config|
end
