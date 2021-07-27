require "sinatra"
require "require_all"

require_rel "db", "models"

get '/' do
    erb :index
end

get '/add' do
    erb :add
end

post '/add' do
    @rem = Reminder.new
    @rem.load(params)

    if @rem.valid?
        @rem.save_changes
        redirect '/add'
    end

    erb :add
end

get '/view_all' do
    @rems = Reminder.all
    erb :all
end

get '/now' do
end
