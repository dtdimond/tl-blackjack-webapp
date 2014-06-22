require 'rubygems'
require 'sinatra'

set :sessions, true

get '/test' do
  erb :"test/test"
end



