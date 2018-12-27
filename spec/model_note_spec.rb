require File.join($__lib__,'database','database_service')
describe 'Model "Note"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
        end
    end

    context 'akcje CRUD' do
        before do
            @dbs = DatabaseService.new Sequel.sqlite
        end

        it 'dodawanie wpisów' do
            
        end

        it 'modyfikowanie wpisów' do
            
        end

        it 'usuwanie wpisów' do
            
        end

        it 'czytanie wpisów' do
       
        end
    end

    context 'walidacja' do

        
        it 'poprawny wpis' do

        end

        it 'niepoprawne wpisy' do

        end
    end

    context 'asocjacja student-note' do

    end
end