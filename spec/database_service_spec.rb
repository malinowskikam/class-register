require File.join($__lib__,'database','database_service')

describe 'Zarządzanie bazami danych' do
    context 'obiekt managera' do 
        it 'utworzenie' do
            expect(DatabaseService.new Sequel.sqlite).not_to be nil
        end
        
        it 'testowanie połączenia' do
            dbs = DatabaseService.new Sequel.sqlite
            expect(dbs.connected?).to be true
        end
    end

    context 'tworzenie tabel' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
        end

        it 'tabela students' do
            expect(@db.table_exists? :students).to be true
        end

        it 'tabela notes' do
            expect(@db.table_exists? :notes).to be true
        end

        it 'tabela grades' do
            expect(@db.table_exists? :grades).to be true
        end

        it 'tabela subjects' do
            expect(@db.table_exists? :subjects).to be true
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

        it 'brak połączenia' do
            
            expect{(DatabaseService.new Sequel::Database.new)}.to raise_error StandardError
        end

        it 'zajęte nazwy tabel' do
            db = DatabaseService.new Sequel.sqlite

            expect{(db.deploy_table_students)}.to raise_error StandardError
            expect{(db.deploy_table_subjects)}.to raise_error StandardError
            expect{(db.deploy_table_notes)}.to raise_error StandardError
            expect{(db.deploy_table_grades)}.to raise_error StandardError
        end
    end
end