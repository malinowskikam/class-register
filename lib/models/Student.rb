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
end