require File.join($__lib__,'database','database_service')
class ModelGradeTest < Minitest::Test
    class ModelObjectTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_tworzenie
            g = Grade.new
            assert_instance_of(Grade,g)
        end
    end

    class CRUDTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_dodawanie_wpisow
            st = Student.new
            st.firstname = 'Jan'
            st.lastname = 'Kowalski'
            st.birthdate = DateTime.new(1970,1,1)
            st.student_class = '3A'
            st.student_number = 4
            st.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = st
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            assert_equal 1, (Grade.select.all.count)
        end

        def test_modyfikowanie_wpisow
            st = Student.new
            st.firstname = 'Jan'
            st.lastname = 'Kowalski'
            st.birthdate = DateTime.new(1970,1,1)
            st.student_class = '3A'
            st.student_number = 4
            st.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = st
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            g.grade = '5+'
            g.date = DateTime.new(1971,1,1)
            g.save

            assert_equal ['5+'], ([Grade[g.id].grade])
        end

        def test_usuwanie_wpisow 
            st = Student.new
            st.firstname = 'Jan'
            st.lastname = 'Kowalski'
            st.birthdate = DateTime.new(1970,1,1)
            st.student_class = '3A'
            st.student_number = 4
            st.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = st
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            g.delete

            assert_equal 0, (Grade.select.all.count)
        end

        def test_czytanie_wpisow
            st1 = Student.new
            st1.firstname = 'Jan'
            st1.lastname = 'Kowalski'
            st1.birthdate = DateTime.new(1970,1,1)
            st1.student_class = '3A'
            st1.student_number = 4
            st1.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = st1
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            g = Grade.new
            g.grade = '2'
            g.student = st1
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            assert_equal 2, (Grade.select.all.count)
        end
    end

    class ValidationTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end

        def test_poprawny_wpis 
            st = Student.new
            st.firstname = 'Jan'
            st.lastname = 'Kowalski'
            st.birthdate = DateTime.new(1970,1,1)
            st.student_class = '3A'
            st.student_number = 4
            st.save

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = st
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            assert_equal true, (g.valid?)
        end

        def test_niepoprawne_wpisy
            invalid_grades = [
                [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, nil, "1-1-1970"],
                [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 3, nil],
                [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, nil],
                [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, [1,2,3]],
                [Student.new {|s| s.id=1}, Student.new {|s| s.id=1}, '39 ', DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1}, nil, '3', "1-1-1970"],
                [Student.new {|s| s.id=1}, nil, '3+',DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1}, nil, 5542, DateTime.new(1970,1,1)],
                [nil, nil, '3+', DateTime.new(1970,1,1)]
            ]

            invalid_grades.each do |grade|
                g = Grade.new
                g.student = grade[0]
                g.subject = grade[1]
                g.grade = grade[2]
                g.date = grade[3]
                assert_equal false, (g.valid?)
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

            su = Subject.new
            su.name = "Matematyka"
            su.save

            g = Grade.new
            g.grade = '4-'
            g.student = s
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save

            g.student.lastname='Kowalskii'
            g.student.save

            s1 = Student[:lastname => 'Kowalski']
            s2 = Student[:lastname => 'Kowalskii']

            assert_nil (s1)
            refute_nil (s2)
        end

        def test_dostep_do_obiektu_subject
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

            g.subject.name = "Fizyka"
            g.subject.save

            s1 = Subject[:name => 'Matematyka']
            s2 = Subject[:name => 'Fizyka']

            assert_nil (s1)
            refute_nil (s2)
        end
    end

    class MenuHelpersTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
  
        def test_drukowanie_naglowka
            exp = "Id   | Przedmiot                      | Data wystawienia          | Ocena | Nazwisko                      \n---------------------------------------------------------------------------------------------------------------"
            assert_equal exp,(Grade.print_header)
        end
  
        def test_drukowanie_oceny
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
    
            exp = "1    | Matematyka                     | 1970-01-01                | 4-    | Kowalski                      "
            assert_equal exp,(g.to_s)
        end
    end

    class QueryTest < Minitest::Test
        def setup
            @dbs = DatabaseService.new Sequel.sqlite
        end
  
        def test_q_oceny_z_przedmiotu
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
    
            g2 = Grade.new
            g2.grade = '5+'
            g2.student = s
            g2.subject = su
            g2.date = DateTime.new(1970,1,1)
            g2.save
    
            assert_equal [g, g2],(Grade.get_by_subject su)
        end
  
        def test_q_oceny_z_przedmiotu_brak
            su = Subject.new
            su.name = "Matematyka"
            su.save
    
            assert_nil (Grade.get_by_subject su)
        end
  
        def test_q_oceny_studenta_z_przedmiotu
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
    
            assert_equal [g],(Grade.get_by_student_and_subject s,su)
        end
  
        def test_q_oceny_studenta_z_przedmiotu_brak
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
    
            assert_nil (Grade.get_by_student_and_subject s,su)
        end
  
        def test_ocena_to_f_bez_znaku
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
            g.grade = '4'
            g.student = s
            g.subject = su
            g.date = DateTime.new(1970,1,1)
            g.save
    
            assert_in_delta 4.0,(g.to_f),0.0001
        end
  
        def test_ocena_to_f_ze_znakiem
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
    
            assert_in_delta 3.66666,(g.to_f),0.0001
        end
    end
end