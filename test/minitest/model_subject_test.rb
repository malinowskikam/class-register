require File.join($__lib__,'database','database_service')
class ModelSubjectTest < Minitest::Test
  class ModelSubjectTworzenieTest < Minitest::Test
    def setup
      @dbs = DatabaseService.new Sequel.sqlite
    end
        
	def test_tworzenie
            s = Subject.new
            assert_instance_of(Subject,s)
        end
    end

  class ModelSubjectCRUDTest < Minitest::Test
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

  class ModelSubjectWalidacjaTest < Minitest::Test
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
          nil, 'W--F', '', 'język niemiecki', 'matematyka'
      ]

      invalid_subjects.each do |subject|
        s = Subject.new
        s.name = subject
        assert_equal false, (s.valid?)
      end
    end
  end
end