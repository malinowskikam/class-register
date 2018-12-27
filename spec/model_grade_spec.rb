require File.join($__lib__,'database','database_service')
describe 'Model "Grade"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            g = Grade.new
            expect(g).to be_instance_of Grade
        end
    end


    context 'akcje CRUD' do
      before do
        @dbs = DatabaseService.new Sequel.sqlite
      end

      it 'dodawanie wpisów' do
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
        g.weight = 1
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(Grade.select.all.count).to eq 1
      end

      it 'modyfikowanie wpisów' do
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
        g.weight = 1.0
        g.date = DateTime.new(1970,1,1)
        g.save

        g.grade = '5+'
        g.date = DateTime.new(1971,1,1)
        g.save

        expect([Grade[g.id].grade]).to eq ['5+']
      end

      it 'usuwanie wpisów' do
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
        g.weight = 1.0
        g.date = DateTime.new(1970,1,1)
        g.save

        g.delete

        expect(Note.select.all.count).to eq 0
      end

      it 'czytanie wpisów' do
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
        g.weight = 1.0
        g.date = DateTime.new(1970,1,1)
        g.save

        g = Grade.new
        g.grade = '2'
        g.student = st1
        g.subject = su
        g.weight = 1.1
        g.date = DateTime.new(1970,1,1)
        g.save

        expect(Grade.select.all.count).to eq 2
      end
    end

  context 'walidacja' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    let(:invalid_grades) do
      [
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, '3', 3, "1-1-1970"],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 3, 3, 333],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, 1, DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, Subject.new {|s| s.id=1}, 5542, 6, [1,2,3]],
          [Student.new {|s| s.id=1}, Student.new {|s| s.id=1}, '3', 4, DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, '3', 2, "1-1-1970"],
          [Student.new {|s| s.id=1}, nil, '3+', 2, DateTime.new(1970,1,1)],
          [Student.new {|s| s.id=1}, nil, 5542, 3333, DateTime.new(1970,1,1)],
          [nil, nil, '3+', 2, DateTime.new(1970,1,1)]
      ]
    end

    it 'poprawny wpis' do
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
      g.weight = 1.0
      g.date = DateTime.new(1970,1,1)
      g.save

      expect(g.valid?).to be true
    end

    it 'niepoprawne wpisy' do
      invalid_grades.each do |grade|
        g = Grade.new
        g.student = grade[0]
        g.subject = grade[1]
        g.grade = grade[2]
        g.weight = grade[3]
        g.date = grade[4]
        expect(g.valid?).to be false
      end
    end
  end

  context 'asocjacja grade-student' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    it 'dostęp do obiektu student' do
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
      g.weight = 1.0
      g.date = DateTime.new(1970,1,1)
      g.save

      g.student.lastname='Kowalskii'
      g.student.save

      s1 = Student[:lastname => 'Kowalski']
      s2 = Student[:lastname => 'Kowalskii']

      expect(s1).to be nil
      expect(s2).not_to be nil
    end
  end

  context 'asocjacja grade-subject' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    it 'dostęp do obiektu subject' do
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
      g.weight = 1.0
      g.date = DateTime.new(1970,1,1)
      g.save

      g.subject.name = "Fizyka"
      g.subject.save

      s1 = Subject[:name => 'Matematyka']
      s2 = Subject[:name => 'Fizyka']

      expect(s1).to be nil
      expect(s2).not_to be nil
    end
  end
end