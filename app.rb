require "sinatra"
require "require_all"
require "date"
require "net/https"
require "uri"
require "socket"
require "json"

require_rel "db", "models"

# Generic landing page
get '/' do
    erb :index
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
    @rems = Reminder.order(:date)
    erb :all
end

# View for displaying current reminders
get '/now' do
    redirect "/date/#{Date.today}"
end

get '/date/:date' do
    @date_obj = Date.parse(params[:date])
    @today = Date.today
    @am_rems = Reminder.where(date: @date_obj, time: "AM")
    @pm_rems = Reminder.where(date: @date_obj, time: "PM")

    erb :list
end

# Cron jobs will send a request to this path at set times to send notifications
# to my phone through IFTTT
# Only acceptable values for :time param are 'AM' and 'PM'
get '/cron/:time' do

    # Check param was sent
    if params[:time].nil? || params[:time].empty?
        status 400
        return "Bad request. No time specified"
    end

    time_text = nil
    if params[:time] == "AM"
        time_text = "morning"
    elsif params[:time] == "PM"
        time_text = "evening"
    else
        status 400
        return "Bad request. Invalid time specified"
    end

    # Get the number of reminders for the current day and time
    num_rems = Reminder.where(date: Date.today, time: params[:time]).count.to_s

    # Get own IP address to send as the URL for the IFTTT notification
    ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    this_ip = ip.ip_address
    notif_address = "http://#{this_ip}:4567/now"

    # Get the URL for the IFTTT notification
    uri = URI.parse("https://maker.ifttt.com/trigger/#{ENV["IFTTTEVENT"]}/with/key/#{ENV["IFTTTKEY"]}")
    # Must use HTTPS to make requests to IFTTT
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = {value1: num_rems, value2: time_text, value3: notif_address}.to_json
    request["Content-Type"] = "application/json"
    # Make the request to IFTTT
    response = https.request(request)
    return "done"
end
