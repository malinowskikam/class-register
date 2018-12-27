require 'sequel'

class DatabaseService
    @db
    attr_accessor :db

    def initialize db
        raise ArgumentError, '"db" nie jest obiektem bazy danych' unless database_valid? db
        @db=db
        raise ArgumentError, 'brak połączenia z "db"' unless connected?
        Sequel::Model.db=db
        generate_models
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

    def deploy_table_students
        raise StandardError, 'Tabela "students" już istnieje' unless !@db.table_exists? :students
        @db.create_table :students do
            primary_key :id
            String :firstname, null: false
            String :lastname, null: false
            DateTime :birthdate, null: false
        end
    end
    def deploy_table_subjects
        raise StandardError, 'Tabela "subjects" już istnieje' unless !@db.table_exists? :subjects
        @db.create_table :subjects do
            primary_key :id
            String :name, null: false
        end
    end
    def deploy_table_grades
        raise StandardError, 'Tabela "grades" już istnieje' unless !@db.table_exists? :grades
        @db.create_table :grades do
            primary_key :id
            foreign_key :id_student, :students, on_delete: :cascade,  null: false
            foreign_key :id_subject, :subjects, on_delete: :cascade,  null: false
            Integer :note, null: false
            String :sign, fixed: true, size: 1
            Double :weight, null: false
            DateTime :date, null: false
        end
    end
    def deploy_table_notes
        raise StandardError, 'Tabela "notes" już istnieje' unless !@db.table_exists? :notes
        @db.create_table :notes do
            primary_key :id
            String :text, null: false
            DateTime :date, null: false
        end
    end
    def generate_models
        if !@db.table_exists? :students
            deploy_table_students
        end
        if !@db.table_exists? :subjects
            deploy_table_subjects
        end
        if !@db.table_exists? :notes
            deploy_table_notes
        end
        if !@db.table_exists? :grades
            deploy_table_grades
        end
        require File.join($__lib__,'models','Grade')
        require File.join($__lib__,'models','Note')
        require File.join($__lib__,'models','Student')
        require File.join($__lib__,'models','Subject')

        Student.set_dataset @db[:students]
        Subject.set_dataset @db[:subjects]
        Note.set_dataset @db[:notes]
        Grade.set_dataset @db[:grades]
    end
end
