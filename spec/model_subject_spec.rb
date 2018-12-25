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
end