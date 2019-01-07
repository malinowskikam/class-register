require File.join($__lib__,'database','database_service')
class ModelSubjectTest < Minitest::Test
    class ModelObjectTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
        
	      def test_tworzenie
            s = Subject.new
            assert_instance_of(Subject,s)
        end
    end

    class CRUDTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_dodawanie_wpisow
            s = Subject.new
            s.name = 'Matematyka'
            s.save

            f = Subject[:name => 'Matematyka']

            refute_nil (f)
        end

        def test_modyfikowanie_wpisow
            s = Subject.new
            s.name = 'WF'
            s.save

            f = Subject[1]
            f.name = 'Język polski'
            f.save_changes

            s1 = Subject[:name => 'WF']
            s2 = Subject[:name => 'Język polski']

            assert_nil (s1)
            refute_nil (s2)
        end

        def test_usuwanie_wpisow
            s = Subject.new
            s.name = 'Historia'
            s.save

            f = Subject[:name => 'Historia']
            f.delete

            ss = Subject[:name => 'Historia']
            assert_nil (ss)
        end

        def test_czytanie_wpisow
            s = Subject.new
            s.name = 'Zajęcia praktyczne'
            s.save

            s = Subject.new
            s.name = 'Godzina wychowawcza'
            s.save

            s = Subject.new
            s.name = 'Plastyka'
            s.save

            assert_equal 3, (Subject.all.length)
        end
    end

    class ValidationTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_poprawny_wpis
            s = Subject.new
            s.name = 'Język angielski'

            assert_equal true, (s.valid?)    
        end

        def test_niepoprawne_wpisy
            invalid_subjects =  [
                nil, 'W--F', '', 'język niemiecki', 'matematyka', 1
            ]

            invalid_subjects.each do |subject|
                s = Subject.new
                s.name = subject
                assert_equal false, (s.valid?)
            end
        end
    end

    class MenuHelpersTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
    
        def test_drukowanie_przedmiotu
            s = Subject.new
            s.name = 'Język angielski'
            s.save
        
            assert_equal ('Język angielski               '),(s.to_s)
        end
    
        def test_drukowanie_naglowka
            assert_equal ("Nazwa                         \n------------------------------"),(Subject.print_header)
        end
    end

    class QueryTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
    
        def test_q_na_podstawie_nazwy_istnieje
            s = Subject.new
            s.name = 'Język angielski'
            s.save
        
            assert_equal s,(Subject.get_by_name s.name)
        end
    
        def test_q_na_podstawie_nazwy_nie_istnieje
            assert_nil (Subject.get_by_name "Przedmiot")
        end
    
        def test_q_na_podstawie_nazwy_nieprawidlowe
            invalid_names = [
                nil,
                "tretgfdvgs",
                "aaAA",
                "123",
                1,
                1.0,
                [1,2,3],
                "a a a",
                ""
            ]
            invalid_names.each do |name|
                assert_nil (Subject.get_by_name name)
            end
        end
    
        def test_avg_wszystkich_uczniów_z_przedmiotu
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
            s2.student_number = 1
            s2.save
        
            su = Subject.new
            su.name = "Matematyka"
            su.save
        
            g = Grade.new
            g.grade = '4-'
            g.student = s1
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save
        
            gg = Grade.new
            gg.grade = '5-'
            gg.student = s1
            gg.subject = su
            gg.date = DateTime.new(1970,1,1)
            gg.save
        
            gg = Grade.new
            gg.grade = '5+'
            gg.student = s2
            gg.subject = su
            gg.date = DateTime.new(1970,1,1)
            gg.save
        
            assert_in_delta 4.555555,(su.get_avg),0.0001
        end
    
        def test_avg_wszystkich_uczniów_z_przedmiotu_brak_ocen
            su = Subject.new
            su.name = "Matematyka"
            su.save
        
            assert_in_delta 0.0,(su.get_avg),0.0001
        end
    end
end