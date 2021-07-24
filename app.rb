require "sinatra"

get '/' do
    erb :index
end

get '/add' do
    erb :add
end

post '/add' do
end

get '/view_all' do
end

get '/now' do
end
