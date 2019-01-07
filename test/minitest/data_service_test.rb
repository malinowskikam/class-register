require File.join($__lib__,'database','data_service')

class DataServiceTest < Minitest::Test
    class ManagerObjectObjectTest < Minitest::Test 
        def test_utworzenie
            refute_nil (DataService.new Sequel.sqlite)
        end
        
        def test_polaczenia
            das = DataService.new Sequel.sqlite
            assert_equal true, (das.connected?)
        end
    end

    class FileImportTest < Minitest::Test
        def setup
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        def test_tabela_student
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;1A;1\n");
            f.write("3;Bronisład;Dudziak;1970-01-03 00:00:00;1A;3\n");
            f.write("2;Andrzej;Kowalski;1970-01-02 00:00:00;1A;2\n");

            f.close

            @das.import_data :students,'temp.csv'

            File.delete 'temp.csv'

            assert_equal 3,Student.select.all.count
        end

        def test_tabela_subjects
            f = File.open("temp.csv","w")
            f.write("1;J. polski\n");
            f.write("3;Matematyka\n");
            f.write("2;W-F\n");

            f.close

            @das.import_data :subjects,'temp.csv'

            File.delete 'temp.csv'

            assert_equal 3,Subject.select.all.count
        end

        def test_tabela_notes
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

            assert_equal 3,Note.select.all.count
        end

        def test_tabela_grades
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

            assert_equal 3,Grade.select.all.count
        end
    end

    class RamImportTest < Minitest::Test
        def setup
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        def test_testowe_dane
            @das.deploy_demo_data

            refute_equal 0,Student.select.all.count
            refute_equal 0,Note.select.all.count
            refute_equal 0,Grade.select.all.count
            refute_equal 0,Subject.select.all.count
        end
    end

    class FileExportTest < Minitest::Test
        def setup
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
            @testfile = "test.csv"
        end

        def test_tabela_students
            @das.deploy_demo_data
            @das.export_data :students,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            assert_equal Student.select.all.count,lines
        end

        def test_tabela_subjects
            @das.deploy_demo_data
            @das.export_data :subjects,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            assert_equal Subject.select.all.count,lines        
        end

        def test_tabela_notes
            @das.deploy_demo_data
            @das.export_data :notes,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            assert_equal Note.select.all.count,lines        
        end

        def test_tabela_grades
            @das.deploy_demo_data
            @das.export_data :grades,@testfile
            lines = File.read(@testfile).each_line.count
            File.delete @testfile
            assert_equal Grade.select.all.count,lines        
        end
    end

    class InitializationErrorTest < Minitest::Test
        def test_nieprawidlowa_baza
            invalid_db = [nil,1,1.0,'1',"1",[nil,1]]
            invalid_db.each do |db|
                assert_raises (ArgumentError){(DataService.new db)}
            end
        end

        def test_brak_polaczenia
            assert_raises(StandardError){(DataService.new Sequel::Database.new)}
        end
    end

    class ImportErrorTest < Minitest::Test
        def setup
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
        end

        def test_nieprawidlowe_zrodla
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
                assert_raises(InvalidSourceError){(@das.import_data line[0],line[1])}
            end
        end

        def test_nieprawidlowa_tabela
            assert_raises(InvalidTableError){(@das.import_data :invalid_table, [[1],[2],[3]])}
        end

        def test_nieprawidlowe_linie_w_zrodle
            nieprawidłowe_linie = [
                [:students, [[1,'Jan',nil,DateTime.new(1970,1,1),'1',1]],[0,[1]]],
                [:grades,[[1,Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, [1,2,3]]],[0,[1]]],
                [:subjects,[[1,'język niemiecki']],[0,[1]]],
                [:notes,[[1,Student.new {|s| s.id=1},'',nil]],[0,[1]]],
            ]
            
            nieprawidłowe_linie.each do |line|
                assert_equal line[2],(@das.import_data line[0],line[1])
            end
        end

        def test_nieprawidlowe_linie_w_plikach
            f = File.open("temp.csv","w")
            f.write("1;Jan;Nowak;1970-01-01 00:00:00;rjf7834g587347g;1\n");
            f.close
            assert_equal [0,[1]],(@das.import_data :students,"temp.csv")

            f = File.open("temp.csv","w")
            f.write("1;j polski\n");
            f.close
            assert_equal [0,[1]],(@das.import_data :subjects,"temp.csv")

            f = File.open("temp.csv","w")
            f.write("1;1;1;48v348h848g4;1970-01-03 00:00:00\n");
            f.close
            assert_equal [0,[1]],(@das.import_data :grades,"temp.csv")

            f = File.open("temp.csv","w")
            f.write("1;1;Uwaga 1;data-jakas\n");
            f.close
            assert_equal [0,[1]],(@das.import_data :notes,"temp.csv")
            
            File.delete 'temp.csv'
        end

        def test_nieistniejacy_plik_zrodla
            assert_raises(StandardError){(@das.import_data :students, "nieistniejacyplik")}
        end
    end

    class ExportErrorsTest < Minitest::Test
        def setup
            @db = Sequel.sqlite
            @dbs = DatabaseService.new @db
            @das = DataService.new @db
            @testfile = "test.csv"
        end

        def test_nieprawidlowa_tabela
            assert_raises(InvalidTableError){(@das.export_data :invalid_table, "temp.csv")}
            File.delete("temp.csv")
        end

        def test_nienadpisywalny_plik
            assert_raises(ArgumentError){(@das.export_data :students, "\0")}
        end
    end
end