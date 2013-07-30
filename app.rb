require 'sinatra'
require './lib/calc_data'

get '/' do
  erb :index
end

get '/search' do
  @result = CalcData.new(params[:name]).favourite_language
  erb :result
end
