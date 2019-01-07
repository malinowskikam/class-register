require File.join($__lib__,'database','database_service')
describe 'Model "Subject"' do
  context 'obiekt modelu' do
    it 'tworzenie' do
      dbs = DatabaseService.new Sequel.sqlite #tworzenie modeli
      s = Subject.new
      expect(s).to be_instance_of Subject
    end
  end

  context 'akcje CRUD' do
    before do
      #tworzenie modeli
      @dbs = DatabaseService.new Sequel.sqlite
    end

    it 'dodawanie wpisów' do
      s = Subject.new
      s.name = 'Matematyka'
      s.save

      f = Subject[:name => 'Matematyka']

      expect(f).not_to be nil
    end

    it 'modyfikowanie wpisów' do
      s = Subject.new
      s.name = 'WF'
      s.save

      f = Subject[1]
      f.name = 'Język polski'
      f.save_changes

      s1 = Subject[:name => 'WF']
      s2 = Subject[:name => 'Język polski']

      expect(s1).to be nil
      expect(s2).not_to be nil
    end

    it 'usuwanie wpisów' do
      s = Subject.new
      s.name = 'Historia'
      s.save

      f = Subject[:name => 'Historia']
      f.delete

      ss = Subject[:name => 'Historia']
      expect(ss).to be nil
    end

    it 'czytanie wpisów' do
      s = Subject.new
      s.name = 'Zajęcia praktyczne'
      s.save

      s = Subject.new
      s.name = 'Godzina wychowawcza'
      s.save

      s = Subject.new
      s.name = 'Plastyka'
      s.save

      expect(Subject.all.length).to eq 3
    end
  end

  context 'walidacja' do
    before do
      #tworzenie modeli
      @dbs = DatabaseService.new Sequel.sqlite
    end

    let(:invalid_subjects) do
      [
          nil, 'W--F', '', 'język niemiecki', 'matematyka'
      ]
    end

    it 'poprawny wpis' do
      s = Subject.new
      s.name = 'Język angielski'

      expect(s.valid?).to be true
    end

    it 'niepoprawne wpisy' do
      invalid_subjects.each do |subject|
        s = Subject.new
        s.name = subject
        expect(s.valid?).not_to be true
      end
    end
  end

  context 'metody związane z obsługą menu' do
    before do
      @dbs = DatabaseService.new Sequel.sqlite
    end

    let(:invalid_names) do
      [
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
    end

    it "pobieranie przedmiotu z bazy na podstawie nazwy - przedmiot istnieje" do
      s = Subject.new
      s.name = 'Język angielski'
      s.save

      expect(Subject.get_by_name s.name).to eq(s)
    end

    it "pobieranie przedmiotu z bazy na podstawie nazwy - przedmiot nie istnieje" do
      expect(Subject.get_by_name "Przedmiot").to eq(nil)
    end

    it "pobieranie przedmiotu z bazy na podstawie nazwy - nieprawidłowa nazwa przedmiotu" do
      invalid_names.each do |name|
        expect(Subject.get_by_name name).to eq(nil)
      end
    end

    it 'drukowanie przedmiotu' do
      s = Subject.new
      s.name = 'Język angielski'
      s.save

      expect(s.to_s).to eq('Język angielski               ')
    end

    it 'drukowanie nagłówka tabeli' do
      expect(Subject.print_header).to eq("Nazwa                         \n------------------------------")
    end

    it "średnia wszystkich uczniów z danego przedmiotu - przy istniejących ocenach" do
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

      expect(su.get_avg).to eq(4.555555555555556)
    end

    it "średnia wszystkich uczniów z danego przedmiotu - przy nieistniejących ocenach" do
      su = Subject.new
      su.name = "Matematyka"
      su.save

      expect(su.get_avg).to eq(0.0)
    end
  end
end