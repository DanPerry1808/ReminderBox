class Reminder < Sequel::Model

    def load(params)
        self.title = params.fetch("title").strip
        self.desc = params.fetch("desc").strip
        self.date = params.fetch("date").strip
        self.time = params.fetch("time").strip
    end

    def validate
        super
        errors.add("title", "cannot be blank") if title.nil? || title.empty?
        errors.add("date", "cannot be blank") if date.nil?
        errors.add("time", "cannot be blank") if time.nil? || time.empty?
    end

end
