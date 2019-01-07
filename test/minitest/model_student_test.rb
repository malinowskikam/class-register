require File.join($__lib__,'database','database_service')
class ModelStudentTest < Minitest::Test
    class ModelObjectTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
        
	    def test_tworzenie
            s = Student.new
            assert_instance_of(Student,s)
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

            f = Student[:firstname => 'Jan',:lastname => 'Kowalski']

            refute_nil (f)
        end

        def test_modyfikowanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save


            f = Student[1]
            f.lastname = 'Nowak'
            f.save_changes

            s1 = Student[:lastname => 'Kowalski']
            s2 = Student[:lastname => 'Nowak']

            assert_nil (s1)
      	    refute_nil (s2)
        end

        def test_usuwanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            f = Student[:lastname => 'Kowalski']
            f.delete

            s1 = Student[:lastname => 'Kowalski']
            assert_nil (s1)
        end

        def test_czytanie_wpisow
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            s = Student.new
            s.firstname = 'Artur'
            s.lastname = 'Nowak'
            s.birthdate = DateTime.new(1970,10,10)
            s.student_class = '3A'
            s.student_number = 2
            s.save

            s = Student.new
            s.firstname = 'Dariusz'
            s.lastname = 'Nazwisko'
            s.birthdate = DateTime.new(1971,1,1)
            s.student_class = '3A'
            s.student_number = 1
            s.save

            assert_equal 3, (Student.all.length)
        end
    end

    class ValidationTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
        
        def test_poprawny_wpis
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Nowak'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            
            assert_equal true, (s.valid?)
        end

        def test_niepoprawne_wpisy
	        invalid_students = [
                [nil,'Nazwisko',DateTime.new(1970,1,1),'1',1],
                ['','Nazwisko',DateTime.new(1970,1,1),'1',1],
                ['jan','Nazwisko',DateTime.new(1970,1,1),'1',1],
                ['Jan',nil,DateTime.new(1970,1,1),'1',1],
                ['Jan','',DateTime.new(1970,1,1),'1',1],
                ['Jan','Nazwisko',nil,'1',1],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),'',1],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),nil,1],
                ['Jan','na12e1h821',DateTime.new(1970,1,1),'dklasdmief',1],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),'1',-11],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),'1',nil],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),'1',0],
                ['Jan','Nazwisko',DateTime.new(1970,1,1),'1',-10]
            ]

            invalid_students.each do |student|
                s = Student.new
                s.firstname = student[0]
                s.lastname = student[1]
                s.birthdate = student[2]
                s.student_class=student[3]
                s.student_number=student[4]

                assert_equal false, (s.valid?)
            end
        end

        def test_unikalny_zestaw_klasa_numer_w_dzienniku
            s1 = Student.new
            s1.firstname = 'Jan'
            s1.lastname = 'Nowak'
            s1.birthdate = DateTime.new(1970,1,1)
            s1.student_class = '3A'
            s1.student_number = 4
            s1.save

            s2 = Student.new
            s2.firstname = 'Andrzej'
            s2.lastname = 'Kowalski'
            s2.birthdate = DateTime.new(1970,1,1)
            s2.student_class = '3A'
            s2.student_number = 4

            assert_raises (Sequel::ValidationFailed) {(s2.save)}
        end
    end

    class MenuHelpersTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_drukowanie_studenta
            s1 = Student.new
            s1.firstname = 'Jan'
            s1.lastname = 'Nowak'
            s1.birthdate = DateTime.new(1970,1,1)
            s1.student_class = '3A'
            s1.student_number = 4
            s1.save

            exp = "Jan                  | Nowak                | 1970-01-01      | 3A         | 4              "
            assert_equal exp,(s1.to_s)
        end

        def test_drukowanie_naglowka
            exp = "Imię                 | Nazwisko             | Data urodzenia  | Klasa      | Numer w dzienniku\n----------------------------------------------------------------------------------------------"
            assert_equal exp,(Student.print_header)
        end
    end

    class QueryTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_q_po_klasie_i_numerze_istnieje
            s1 = Student.new
            s1.firstname = 'Jan'
            s1.lastname = 'Nowak'
            s1.birthdate = DateTime.new(1970,1,1)
            s1.student_class = '3A'
            s1.student_number = 4
            s1.save

            assert_equal s1,(Student.get_by_class_and_number s1.student_class,s1.student_number)
        end

        def test_q_po_klasie_i_numerze_nie_istnieje
            assert_nil (Student.get_by_class_and_number '1', 1)
        end

        def test_q_po_klasie_i_numerze_nieprawidlowe
            invalid_data = [
                [nil, nil],
                [1, "test"],
                ["fdsgds", "sfdgfds"],
                [[1,2,3], [1]],
                [nil, 4.0],
                [1.0, 1.0],
                [1, "1"]
            ]

            invalid_data.each do |data|
                assert_nil (Student.get_by_class_and_number data[0],data[1])
            end
        end

        def test_avg_z_przedmiotu
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = s
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            gg = Grade.new
            gg.grade = '5-'
            gg.student = s
            gg.subject = su
            gg.date = DateTime.new(1970,1,1)
            gg.save

            assert_in_delta 4.5,(s.get_avg_of_subject su),0.0001
        end

        def test_avg_z_przedmiotu_brak_ocen
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            assert_in_delta 0.0,(s.get_avg_of_subject su),0.0001
        end

        def test_przedmioty
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            su2 = Subject.new
            su2.name = "Fizyka"
            su2.save

            g = Grade.new
            g.grade = '4-'
            g.student = s
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            gg = Grade.new
            gg.grade = '5-'
            gg.student = s
            gg.subject = su
            gg.date = DateTime.new(1970,1,1)
            gg.save

            assert_equal [su],(s.get_subjects)
        end

        def test_przedmioty_brak
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            assert_equal [],(s.get_subjects)
        end

        def test_avg_z_wszystkich_przedmiotów
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            su2 = Subject.new
            su2.name = "Fizyka"
            su2.save

            g = Grade.new
            g.grade = '4-'
            g.student = s
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            gg = Grade.new
            gg.grade = '5-'
            gg.student = s
            gg.subject = su
            gg.date = DateTime.new(1970,1,1)
            gg.save

            ggg = Grade.new
            ggg.grade = '2'
            ggg.student = s
            ggg.subject = su2
            ggg.date = DateTime.new(1970,1,1)
            ggg.save

            assert_in_delta 3.25,(s.get_avg),0.0001
        end

        def test_avg_z_wszystkich_przedmiotów_brak
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            assert_in_delta 0.0,(s.get_avg),0.0001
        end
    end
end