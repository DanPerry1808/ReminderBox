require "sequel"

DB = Sequel.sqlite "reminders.sqlite3"

unless DB.tables.include? :reminders
    DB.create_table(:reminders) do
        primary_key :id
        String :title
        String :desc, text: true
        Date :date
        String :time, size: 2
    end
end
