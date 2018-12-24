require File.join($__lib__,'database','database_service')
require 'sequel'

describe 'Zarządzanie bazami danych' do
    context 'obiekt managera' do 
        it 'utworzenie' do
            expect(DatabaseService.new Sequel.sqlite).not_to be nil
        end
        
        it 'testowanie połączenia' do
            dbs = DatabaseService.new Sequel.sqlite
            expect(dbs.connected?).to be true

            dbs = DatabaseService.new Sequel::Database.new
            expect(dbs.connected?).to be false
            
        end
    end

    context 'tworzenie tabel' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
        end

        it 'tabela student' do
            @dbs.deploy_table_student
            expect(@db.table_exists? :student).to be true
        end

        it 'tabela note' do
            @dbs.deploy_table_note
            expect(@db.table_exists? :note).to be true
        end

        it 'tabela grade' do
            @dbs.deploy_table_grade
            expect(@db.table_exists? :grade).to be true
        end

        it 'tabela subject' do
            @dbs.deploy_table_student
            @dbs.deploy_table_note
            @dbs.deploy_table_subject
            expect(@db.table_exists? :subject).to be true
        end
    end

    context 'błędy' do
        let(:invalid_db) do
            [nil,1,1.0,'1',"1",[nil,1]]
        end

        it 'nieprawidłowa baza' do
            invalid_db.each do |db|
                expect{(DatabaseService.new db)}.to raise_error ArgumentError
            end
        end

        it 'zajęte nazwy tabel' do
            db = DatabaseService.new Sequel.sqlite
            db.deploy_table_student
            db.deploy_table_subject
            db.deploy_table_note
            db.deploy_table_grade

            expect{(db.deploy_table_student)}.to raise_error StandardError
            expect{(db.deploy_table_subject)}.to raise_error StandardError
            expect{(db.deploy_table_note)}.to raise_error StandardError
            expect{(db.deploy_table_grade)}.to raise_error StandardError
        end
    end
end