class Grade < Sequel::Model
    #id,student_id,subject_id,grade,weight,date

    many_to_one :student, allow_nil: false
    many_to_one :subject, allow_nil: false

    plugin :validation_helpers
    def validate
        validates_presence [:student_id,:subject_id,:grade,:date]
        validates_format /^[1-6][+-]?$/, :grade
    end
end