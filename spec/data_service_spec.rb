require File.join($__lib__,'database','data_service')

describe 'Zarządzanie danymi' do
    context 'obiekt managera' do 
        it 'utworzenie' do
            expect(DataService.new Sequel.sqlite).not_to be nil
        end
        
        it 'testowanie połączenia' do
            dbs = DatabaseService.new Sequel.sqlite
            expect(dbs.connected?).to be true
        end
    end

    context 'import z pliku' do
        
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        it 'tabela students' do
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;1A;1\n");
            f.write("3;Bronisład;Dudziak;1970-01-03 00:00:00;1A;3\n");
            f.write("2;Andrzej;Kowalski;1970-01-02 00:00:00;1A;2\n");

            f.close

            @das.import_data :students,'temp.csv'

            File.delete 'temp.csv'

            expect(Student.select.all.count).to eq 3
        end

        it 'tabela subjects' do
            f = File.open("temp.csv","w")
            f.write("1;J. polski\n");
            f.write("3;Matematyka\n");
            f.write("2;W-F\n");

            f.close

            @das.import_data :subjects,'temp.csv'

            File.delete 'temp.csv'

            expect(Subject.select.all.count).to eq 3
        end

        it 'tabela notes' do
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;1A;1\n");
            f.write("3;Bronisład;Dudziak;1970-01-03 00:00:00;1A;3\n");
            f.write("2;Andrzej;Kowalski;1970-01-02 00:00:00;1A;2\n");

            f.close

            @das.import_data :students,'temp.csv'

            f = File.open("temp.csv","w")
            f.write("1;1;Uwaga 1;1970-01-01 00:00:00\n");
            f.write("3;2;Uwaga 123124;1970-01-03 00:00:00\n");
            f.write("2;2;Nagana jeden.;1970-01-02 00:00:00\n");

            f.close

            @das.import_data :notes,'temp.csv'

            File.delete 'temp.csv'

            expect(Note.select.all.count).to eq 3
        end

        it 'tabela grades' do
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;1A;1\n");
            f.write("3;Bronisład;Dudziak;1970-01-03 00:00:00;1A;3\n");
            f.write("2;Andrzej;Kowalski;1970-01-02 00:00:00;1A;2\n");

            f.close

            @das.import_data :students,'temp.csv'

            f = File.open("temp.csv","w")
            f.write("1;J. polski\n");
            f.write("3;Matematyka\n");
            f.write("2;W-F\n");

            f.close

            @das.import_data :subjects,'temp.csv'

            f = File.open("temp.csv","w")
            f.write("1;1;1;4;1970-01-03 00:00:00\n");
            f.write("2;2;3;3+;1970-01-01 00:00:00\n");
            f.write("3;3;2;5-;1970-01-02 00:00:00\n");

            f.close

            @das.import_data :grades,'temp.csv'

            expect(Grade.select.all.count).to eq 3

        end
    end
end