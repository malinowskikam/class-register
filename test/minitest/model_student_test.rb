require File.join($__lib__,'database','database_service')
class ModelStudentTest < Minitest::Test
  class ModelStudentTworzenieTest < Minitest::Test
    def setup
      @dbs = DatabaseService.new Sequel.sqlite
    end
        
	def test_tworzenie
            s = Student.new
            assert_instance_of(Student,s)
        end
    end

    class StudentModelCRUDTest < Minitest::Test
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

   class ModelStudentWalidacjaTest < Minitest::Test
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
end