class Subject < Sequel::Model
    #id,name
    one_to_many :grades

    plugin :validation_helpers
    def validate
        validates_presence :name
        validates_unique :name
        validates_schema_types :name
        validates_min_length 2, :name
        validates_format /[A-ZĄĘĆŹŻŚÓŁ]-?[A-ZĄĘĆŹŻŚÓŁa-ząęćśżźół .]+/, :name
    end

    def self.get_by_name name
        return Subject.select.where(name: name).first
    end

    def to_s
        return self.name.ljust(30)
    end

    def self.print_header
        return "Nazwa".ljust(30) + "\n------------------------------"
    end

    def get_avg
        sum = 0.0
        grades = Grade.get_by_subject self

        if grades==nil
            return 0.0
        else
            grades.each do |grade|
                sum = sum + grade.to_f
            end

            return sum/grades.count
        end
    end

    def student? student
        if Grade.select.where(subject: self,student: student).first != nil
            return true
        else
            return false
        end
    end
end