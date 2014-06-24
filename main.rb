require 'rubygems'
require 'sinatra'
require 'pry'

set :sessions, true

get '/test' do
  erb :"test/test"
end

get '/' do
  if session[:name] == nil
    redirect '/name'
  end

  session[:name]
end

get '/name' do
  erb :get_name
end

