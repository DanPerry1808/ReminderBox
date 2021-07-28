require "sinatra"
require "require_all"

require_rel "db", "models"

# Generic landing page
get '/' do
    erb :index
end

# Displays form for adding new reminders
get '/add' do
    erb :add
end

# Handles form for adding new reminders
post '/add' do
    @rem = Reminder.new
    @rem.load(params)

    if @rem.valid?
        @rem.save_changes
        redirect '/add'
    end

    erb :add
end

# View for displaying all current reminders
get '/view_all' do
    @rems = Reminder.all.order(:date)
    erb :all
end

# View for displaying current reminders
get '/now' do
end
