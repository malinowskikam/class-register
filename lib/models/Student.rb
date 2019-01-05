class Student < Sequel::Model
    #id,firstname,lastname,birthdate,student_class,student_number

    one_to_many :notes

    plugin :validation_helpers
    def validate
        super
        validates_presence [:firstname,:lastname,:birthdate,:student_class,:student_number]
        validates_schema_types [:firstname,:lastname,:birthdate,:student_class,:student_number]
        validates_min_length 2, [:firstname,:lastname]
        validates_format /^[1-8][A-Z]?$/, :student_class
        validates_operator(:>, 0, :student_number)
        validates_format /^[A-Z][A-Za-ząęółćżźśĄĘÓŚŻŹĆŁ '-]+$/, [:firstname,:lastname]
        validates_unique [:student_class,:student_number]
    end

    def self.get_by_class_and_number student_class,student_number
        return Student.select.where(student_class: student_class, student_number: student_number).first
    end

    def to_s
        return self.firstname.ljust(20) + ' | ' + self.lastname.ljust(20) + ' | ' + self.birthdate.strftime("%F").ljust(15) + ' | ' + self.student_class.ljust(10) + ' | ' + self.student_number.to_s.ljust(15)
    end

    def self.print_header
        return "Imię".ljust(20) + " | " + "Nazwisko".ljust(20) + " | " + "Data urodzenia".ljust(15) + " | " + "Klasa".ljust(10) + " | " + "Numer w dzienniku".ljust(15) + 
        "\n----------------------------------------------------------------------------------------------"
    end
end