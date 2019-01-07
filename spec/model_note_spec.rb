require File.join($__lib__,'database','database_service')
describe 'Model "Note"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            n = Note.new
            expect(n).to be_instance_of Note
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

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            expect(Note.select.all.count).to eq 1
        end

        it 'modyfikowanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.text = 'Note changed text'
            n.save_changes

            expect([Note[n.id].text]).to eq ['Note changed text']
        end

        it 'usuwanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.delete

            expect(Note.select.all.count).to eq 0
        end

        it 'czytanie wpisów' do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note1 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n = Note.new
            n.student=s
            n.text = 'Note2 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n = Note.new
            n.student=s
            n.text = 'Note3 sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            expect(Note.select.all.count).to eq 3
        end
    end

    context 'walidacja' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        let(:invalid_notes) do
            [
                [nil,'Note1 sample text',DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1},nil,DateTime.new(1970,1,1)],
                [Student.new {|s| s.id=1},'',nil],
                [Student.new {|s| s.id=1},'as',nil]
            ]
        end
        
        it 'poprawny wpis' do
            n = Note.new
            n.student=Student.new {|s| s.id=1}
            n.text = 'Note1 sample text'
            n.date = DateTime.new(1970,1,1)
            
            expect(n.valid?).to be true
        end

        it 'niepoprawne wpisy' do
            invalid_notes.each do |note|
                n=Note.new
                n.student=note[0]
                n.text=note[1]
                n.date=note[2]

                expect(n.valid?).to be false
            end
        end
    end

    context 'asocjacja' do
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

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            n.student.lastname='Nowak'
            n.student.save_changes

            s1 = Student[:lastname => 'Kowalski']
            s2 = Student[:lastname => 'Nowak']

            expect(s1).to be nil
            expect(s2).not_to be nil
        end
    end

    context 'metody związane z obsługą menu' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        it "drukowanie nagłówka tabeli" do
            exp = "Id    | Nazwisko                       | Treść                               | Data wystawienia         \n---------------------------------------------------------------------------------------------------------------"
            expect(Note.print_header).to eq(exp)
        end

        it "drukowanie uwagi 1" do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Note sample text'
            n.date = DateTime.new(1970,1,1)
            n.save

            exp = "1     | Kowalski                       | Note sample text                    | 1970-01-01               "
            expect(n.to_s).to eq(exp)
        end

        it "drukowanie uwagi 2" do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit'
            n.date = DateTime.new(1970,1,1)
            n.save

            exp = "1     | Kowalski                       | Lorem ipsum dolor sit amet, cons... | 1970-01-01               "
            expect(n.to_s).to eq(exp)
        end
    end

    context 'zapytania' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        it "pobieranie istniejących uwag na podstawie studenta" do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            n = Note.new
            n.student=s
            n.text = 'Lorem ipsum dolor sit amet'
            n.date = DateTime.new(1970,1,1)
            n.save

            expect(Note.get_by_student s).to eq([n])
        end

        it "pobieranie nieistniejących uwag na podstawie studenta" do
            s = Student.new
            s.firstname = 'Jan'
            s.lastname = 'Kowalski'
            s.birthdate = DateTime.new(1970,1,1)
            s.student_class = '3A'
            s.student_number = 4
            s.save

            expect(Note.get_by_student s).to eq(nil)
        end
    end
end