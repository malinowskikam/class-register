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

            File.delete 'temp.csv'

            expect(Grade.select.all.count).to eq 3

        end
    end

    context 'import z ramu' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        it 'testowe dane' do
            @das.deploy_demo_data

            expect(Student.select.all.count).not_to eq 0
            expect(Note.select.all.count).not_to eq 0
            expect(Grade.select.all.count).not_to eq 0
            expect(Subject.select.all.count).not_to eq 0
        end
    end

    context 'export do pliku' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
            @testfile = "test.csv"
        end

        it 'tabela students' do
            @das.deploy_demo_data
            @das.export_data :students,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            expect(lines).to eq Student.select.all.count
        end

        it 'tabela subjects' do
            @das.deploy_demo_data
            @das.export_data :subjects,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            expect(lines).to eq Subject.select.all.count
        end

        it 'tabela notes' do
            @das.deploy_demo_data
            @das.export_data :notes,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            expect(lines).to eq Note.select.all.count
        end

        it 'tabela grades' do
            @das.deploy_demo_data
            @das.export_data :grades,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            expect(lines).to eq Grade.select.all.count
        end
    end

    context 'błędy inicjalizacji' do
        let(:invalid_db) do
            [nil,1,1.0,'1',"1",[nil,1]]
        end

        it 'nieprawidłowa baza' do
            invalid_db.each do |db|
                expect{(DataService.new db)}.to raise_error ArgumentError
            end
        end

        it 'brak połączenia' do
            expect{(DataService.new Sequel::Database.new)}.to raise_error StandardError
        end
    end

    context 'błędy importu' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        it 'nieprawidłowe źródła' do
            nieprawidłowe_źródła = [
                [:students,nil],
                [:notes,nil],
                [:grades,nil],
                [:subjects,nil],
                [:students,1],
                [:notes,1],
                [:grades,1],
                [:subjects,1],
                [:students,[]],
                [:notes,[]],
                [:grades,[]],
                [:subjects,[]],
                [:students,Object.new],
                [:notes,Object.new],
                [:grades,Object.new],
                [:subjects,Object.new],
            ]

            nieprawidłowe_źródła.each do |line|
                expect{(@das.import_data line[0],line[1])}.to raise_error InvalidSourceError
            end
        end

        it 'nieprawidłowa tabela' do
            expect{(@das.import_data :invalid_table, [[1],[2],[3]])}.to raise_error InvalidTableError
        end

        it 'nieprawidłowe linie w źródle' do
            nieprawidłowe_linie = [
                [:students, [[1,'Jan',nil,DateTime.new(1970,1,1),'1',1]],[0,[1]]],
                [:grades,[[1,Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, [1,2,3]]],[0,[1]]],
                [:subjects,[[1,'język niemiecki']],[0,[1]]],
                [:notes,[[1,Student.new {|s| s.id=1},'',nil]],[0,[1]]],
            ]
            
            nieprawidłowe_linie.each do |line|
                expect(@das.import_data line[0],line[1]).to eq line[2]
            end
        end

        it 'nieprawidłowe linie w plikach' do
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;rjf7834g587347g;1\n");
            f.close
            expect(@das.import_data :students,"temp.csv").to eq [0,[1]]

            f = File.open("temp.csv","w")
            f.write("1;j polski\n");
            f.close
            expect(@das.import_data :subjects,"temp.csv").to eq [0,[1]]

            f = File.open("temp.csv","w")
            f.write("1;1;1;48v348h848g4;1970-01-03 00:00:00\n");
            f.close
            expect(@das.import_data :grades,"temp.csv").to eq [0,[1]]

            f = File.open("temp.csv","w")
            f.write("1;1;Uwaga 1;data-jakas\n");
            f.close
            expect(@das.import_data :notes,"temp.csv").to eq [0,[1]]
            
            File.delete 'temp.csv'
        end

        it 'nieistniejący plik źródła' do
            expect{(@das.import_data :students, "nieistniejacyplik")}.to raise_error StandardError
        end
    end

    context 'błędy exportu' do
        before do
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        it 'nieprawidłowa tabela' do
            expect{(@das.export_data :invalid_table, "temp.csv")}.to raise_error InvalidTableError
            File.delete("temp.csv")
        end
    end
end