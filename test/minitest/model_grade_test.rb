require File.join($__lib__,'database','database_service')
describe 'Model "Grade"' do
    describe 'obiekt modelu' do
        def 'tworzenie'
            dbs = DatabaseService.new Sequel.sqlite
            g = Grade.new
            @g.must_be_instance_of(Grade)
        end
    end


    describe 'akcje CRUD' do
      before do
        @dbs = DatabaseService.new Sequel.sqlite
      end

      def 'dodawanie wpisów'
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

      def 'modyfikowanie wpisów'
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

      def 'usuwanie wpisów' 
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

        assert_equal 0, (Note.select.all.count)
      end

      def 'czytanie wpisów' 
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

  describe 'walidacja' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    let(:invalid_grades) do
      [
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, '3', "1-1-1970"],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 3, 333],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, [1,2,3]],
          [Student.new {|s| s.id=1}, Student.new {|s| s.id=1}, '3', DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, '3', "1-1-1970"],
          [Student.new {|s| s.id=1}, nil, '3+', DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, 5542, DateTime.new(1970,1,1)],
          [nil, nil, '3+', DateTime.new(1970,1,1)]
      ]
    end

    def 'poprawny wpis' 
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

    def 'niepoprawne wpisy' 
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

  describe 'asocjacja grade-student' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    def 'dostęp do obiektu student' 
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
  end

  describe 'asocjacja grade-subject' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    def 'dostęp do obiektu subject'
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
end