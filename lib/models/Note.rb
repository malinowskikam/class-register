class Note < Sequel::Model
    #id, student_id, text, date
    many_to_one :student

    plugin :validation_helpers
    def validate
        super
        validates_presence [:student_id,:text,:date]
        validates_schema_types [:student_id,:text,:date]
        validates_min_length 3, [:text]
    end

    def self.print_header
        return "Id".ljust(5) + " | " + "Nazwisko".ljust(30) + " | " + "Treść".ljust(35) + " | " + "Data wystawienia".ljust(25) +
        "\n---------------------------------------------------------------------------------------------------------------"        
    end

    def to_s
        if self.text.length<=35
            return self.id.to_s.ljust(5) + " | " + self.student.lastname.ljust(30) + " | " + self.text.ljust(35) + " | " + self.date.strftime('%F').ljust(25)
        else
            return self.id.to_s.ljust(5) + " | " + self.student.lastname.ljust(30) + " | " + self.text[0..31].ljust(32) + "... | " + self.date.strftime('%F').ljust(25)
        end
    end

    def self.get_by_student student
        res = Note.select.where(student: student).all

        if res.count==0
            return nil
        else
            return res
        end
    end
end