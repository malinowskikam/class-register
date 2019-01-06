require File.join($__lib__,'database','database_service')
describe 'Model "Student"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            s = Student.new
            expect(s).to be_instance_of Student
        end
    end

    context 'akcje CRUD' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        it 'dodawanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            f = Student[:firstname => 'Jan',:lastname => 'Kowalski']

            expect(f).not_to be nil
        end

        it 'modyfikowanie wpisów' do
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

            expect(s1).to be nil
            expect(s2).not_to be nil
        end

        it 'usuwanie wpisów' do
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
            expect(s1).to be nil
        end

        it 'czytanie wpisów' do
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

            expect(Student.all.length).to eq 3
        end
    end

    context 'walidacja' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        let(:invalid_students) do
            [
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
        end
        
        it 'poprawny wpis' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Nowak'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            
            expect(s.valid?).to be true
        end

        it 'niepoprawne wpisy' do
            invalid_students.each do |student|
                s = Student.new
                s.firstname = student[0]
                s.lastname = student[1]
                s.birthdate = student[2]
                s.student_class=student[3]
                s.student_number=student[4]

                expect(s.valid?).to be false
            end
        end

        it 'unikalny zestaw klasa/numer w dzienniku' do
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

            expect{(s2.save)}.to raise_error Sequel::ValidationFailed
        end
    end

  context 'metody związane z obsługą menu' do
      before do
          @dbs = DatabaseService.new Sequel.sqlite
      end

      let(:invalid_data) do
          [
              [nil, nil],
              [1, "test"],
              ["fdsgds", "sfdgfds"],
              [[1,2,3], [1]],
              [nil, 4.0],
              [1.0, 1.0],
              [1, "1"]
          ]
      end

      it 'pobieranie studenta z bazy na podstawie klasy oraz numeru w dzienniku - student istnieje' do
          s1 = Student.new
          s1.firstname = 'Jan'
          s1.lastname = 'Nowak'
          s1.birthdate = DateTime.new(1970,1,1)
          s1.student_class = '3A'
          s1.student_number = 4
          s1.save

          expect(Student.get_by_class_and_number s1.student_class,s1.student_number).to eq(s1)
      end

      it 'pobieranie studenta z bazy na podstawie klasy oraz numeru w dzienniku - student nie istnieje' do
        expect(Student.get_by_class_and_number '1', 1).to eq(nil)
      end

    it 'pobieranie studenta z bazy na podstawie klasy oraz numeru w dzienniku - nieprawidłowe dane' do
        invalid_data.each do |data|
            expect(Student.get_by_class_and_number data[0],data[1]).to eq(nil)
        end
    end

      it 'drukowanie studenta' do
          s1 = Student.new
          s1.firstname = 'Jan'
          s1.lastname = 'Nowak'
          s1.birthdate = DateTime.new(1970,1,1)
          s1.student_class = '3A'
          s1.student_number = 4
          s1.save

        expect(s1.to_s).to eq("Jan                  | Nowak                | 1970-01-01      | 3A         | 4              ")
      end

    it 'drukowanie nagłówka tabeli' do
      expect(Student.print_header).to eq ("Imię                 | Nazwisko             | Data urodzenia  | Klasa      | Numer w dzienniku\n----------------------------------------------------------------------------------------------")
    end
  end
end