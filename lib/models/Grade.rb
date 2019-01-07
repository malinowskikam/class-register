class Grade < Sequel::Model
    #id,student_id,subject_id,grade,weight,date

    many_to_one :student, allow_nil: false
    many_to_one :subject, allow_nil: false

    plugin :validation_helpers
    def validate
        validates_presence [:student_id,:subject_id,:grade,:date]
        validates_format /^[1-6][+-]?$/, :grade
    end

    def to_f
        if grade.length==1
            return grade.to_f
        else
            if grade[1]=='+'
                return grade[0..0].to_f + 1.0/3.0
            else
                return grade[0..0].to_f - 1.0/3.0
            end
        end
    end

    def self.get_by_subject subject
        res = Grade.select.where(subject: subject).all

        if res.count==0
            return nil
        else
            return res
        end
    end

    def self.get_by_student_and_subject student,subject
        res = Grade.select.where(subject: subject,student: student).all

        if res.count==0
            return nil
        else
            return res
        end
    end
    
    def self.print_header
        return "Id".ljust(4) + " | " + "Przedmiot".ljust(30) + " | " + "Data wystawienia".ljust(25) + " | " + "Ocena".ljust(5) + " | " + "Nazwisko".ljust(30) +
                "\n---------------------------------------------------------------------------------------------------------------"
    end

    def to_s
        return self.id.to_s.ljust(4) + " | " + self.subject.name.ljust(30) + " | " + self.date.strftime('%F').ljust(25) + " | " + self.grade.ljust(5) + " | " + self.student.lastname.ljust(30)
    end
end