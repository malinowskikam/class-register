class DatabaseService
    @db
    def initialize db
        @db=db
    end

    def deploy_tables
        db.create_table :student do
            primary_key :id
            String :firstname, null: false
            String :lastname, null: false
            DateTime :birthdate, null: false
        end

        db.create_table :subject do
            primary_key :id
            String :name, null: false
        end

        db.create_table :note do
            primary_key :id
            foreign_key :id_student, :student, on_delete: cascade,  null: false
            foreign_key :id_subject, :ssubject, on_delete: cascade,  null: false
            Integer :note, null: false
            String :sign, fixed: true, size: 1
            Double :weight, null: false
            DateTime :date, null: false
        end

        db.create_table :reprimand do
            primary_key :id
            String :text, null: false
            DateTime :date, null: false
        end
    end
end