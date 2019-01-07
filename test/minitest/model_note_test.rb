require File.join($__lib__,'database','database_service')
class ModelNoteTest < Minitest::Test
    class ModelObjectTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
            
        def test_tworzenie
            n = Note.new
            assert_instance_of(Note,n)
        end
    end

    class CRUDTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_dodawanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            assert_equal 1, (Note.select.all.count)
        end

        def test_modyfikowanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.text = 'Note changed text'
            n.save_changes

            assert_equal ['Note changed text'], ([Note[n.id].text]) 
        end

        def test_usuwanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.delete

            assert_equal 0, (Note.select.all.count)
        end

        def test_czytanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note1 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n = Note.new
            n.student=s
            n.text = 'Note2 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n = Note.new
            n.student=s
            n.text = 'Note3 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            assert_equal 3, (Note.select.all.count)
        end
    end

    class ValidationTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
        
        def test_poprawny_wpis
            n = Note.new
            n.student=Student.new {|s| s.id=1}
            n.text = 'Note1 sample text'
            n.date = DateTime.new(1970,1,1)
            
            assert_equal true, (n.valid?)
        end

        def test_niepoprawne_wpisy
	        invalid_notes = [
                [nil,'Note1 sample text',DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1},nil,DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1},'',nil],
                [Student.new {|s| s.id=1},'as',nil]
            ]


            invalid_notes.each do |note|
                n=Note.new
                n.student=note[0]
                n.text=note[1]
                n.date=note[2]

                assert_equal false, (n.valid?)
            end
        end
    end

    class AssociationTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_dostep_do_obiektu_student
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.student.lastname='Nowak'
            n.student.save_changes

            s1 = Student[:lastname => 'Kowalski']
            s2 = Student[:lastname => 'Nowak']

            assert_nil (s1)
      	    refute_nil (s2)
        end
    end

    class MenuHelpersTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_drukowanie_naglowka
            exp = "Id    | Nazwisko                       | Treść                               | Data wystawienia         \n---------------------------------------------------------------------------------------------------------------"
            assert_equal exp,Note.print_header
        end

        def test_drukowanie_uwag_1
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            exp = "1     | Kowalski                       | Note sample text                    | 1970-01-01               "
            assert_equal exp,(n.to_s)
        end

        def test_drukowanie_uwag_2
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
            n.date = DateTime.new(1970,1,1)
            n.save

            exp = "1     | Kowalski                       | Lorem ipsum dolor sit amet, cons... | 1970-01-01               "
            assert_equal exp,(n.to_s)
        end
    end

    class QueryTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_uwagi_studenta
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Lorem ipsum dolor sit amet'
            n.date = DateTime.new(1970,1,1)
            n.save

            assert_equal ([n]),(Note.get_by_student s) 
        end

        def test_brak_uwag_studenta
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            assert_nil (Note.get_by_student s)
        end
    end
end