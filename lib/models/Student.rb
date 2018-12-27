class Student < Sequel::Model
    #id,firstname,lastname,birthdate
    one_to_many :notes
    plugin :validation_helpers
    def validate
        super
        validates_presence [:firstname,:lastname,:birthdate]
        validates_schema_types [:firstname,:lastname,:birthdate]
        validates_min_length 2, [:firstname,:lastname]
        validates_format /^[A-Z][A-Za-ząęółćżźśĄĘÓŚŻŹĆŁ '-]+$/, [:firstname,:lastname]
    end
    
end