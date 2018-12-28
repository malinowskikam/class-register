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
end