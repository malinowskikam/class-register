class DatabaseService
    @db
    def initialize db
        raise ArgumentError, '"db" nie jest obiektem bazy danych' unless database_valid? db
        @db=db
    end

    def database_valid? db
        if(db!=nil and db.is_a? Sequel::Database)
            return true
        else
            return false
        end
    end

    def connected?
        begin
            @db.test_connection
        rescue
            return false
        end
        return true
    end

    def deploy_table_student
        raise StandardError, 'Tabela "student" już istnieje' unless !@db.table_exists? :student
        @db.create_table :student do
            primary_key :id
            String :firstname, null: false
            String :lastname, null: false
            DateTime :birthdate, null: false
        end
    end
    def deploy_table_subject
        raise StandardError, 'Tabela "subject" już istnieje' unless !@db.table_exists? :subject
        @db.create_table :subject do
            primary_key :id
            String :name, null: false
        end
    end
    def deploy_table_note
        raise StandardError, 'Tabela "note" już istnieje' unless !@db.table_exists? :note
        @db.create_table :note do
            primary_key :id
            foreign_key :id_student, :student, on_delete: :cascade,  null: false
            foreign_key :id_subject, :ssubject, on_delete: :cascade,  null: false
            Integer :note, null: false
            String :sign, fixed: true, size: 1
            Double :weight, null: false
            DateTime :date, null: false
        end
    end
    def deploy_table_reprimand
        raise StandardError, 'Tabela "reprimand" już istnieje' unless !@db.table_exists? :reprimand
        @db.create_table :reprimand do
            primary_key :id
            String :text, null: false
            DateTime :date, null: false
        end
    end
end