class Note < Sequel::Model
    #id,id_student,text,date
    many_to_one :student
    plugin :validation_helpers
    def validate
        super
        validates_presence [:id_student,:text,:date]
        validates_schema_types [:id_student,:text,:date]
        validates_min_length 3, [:text]
    end

end