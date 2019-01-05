require File.join($__lib__,'database','database_service')
class DatabaseTest < Minitest::Test

class DatabaseZarzadzanieTest < Minitest::Test 
        def test_utworzenie
            refute_nil (DatabaseService.new Sequel.sqlite)
        end
        
        def testowanie_polaczenia
            dbs = DatabaseService.new Sequel.sqlite
            assert_equal true, (dbs.connected?)
        end
    end

    class DatabaseTworzenieTabelTest < Minitest::Test
    def setup
      @dbs = DatabaseService.new Sequel.sqlite
    end


        def test_tabela_students 
            assert_equal true, (@dbs.table_exists? :students)
        end

        def test_tabela_notes
            assert_equal true, (@dbs.table_exists? :notes)
        end

	def test_tabela_grades 
            assert_equal true, (@dbs.table_exists? :grades)
        end

        def test_tabela_subjects 
            assert_equal true, (@dbs.table_exists? :subjects)
        end
    end

    class DatabaseErrorTest < Minitest::Test
        def test_nieprawidlowa_baza
	    invalid_db = [nil,1,1.0,'1',"1",[nil,1]]
            invalid_db.each do |db|
                assert_raises (ArgumentError) {(DatabaseService.new db)}
            end
        end

        def test_brak_polaczenia
            
            assert_raises (StandardError) {(DatabaseService.new Sequel::Database.new)}
        end

        def test_zajete_nazwy_tabel
            db = DatabaseService.new Sequel.sqlite

            assert_raises (StandardError) {(db.deploy_table_students)}
            assert_raises (StandardError) {(db.deploy_table_subjects)}
            assert_raises (StandardError) {(db.deploy_table_notes)}
            assert_raises (StandardError) {(db.deploy_table_grades)}
        end
    end
end