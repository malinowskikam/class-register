require File.join($__lib__,'database','database_service')
describe 'Model "Note"' do
    context 'obiekt modelu' do
        it 'tworzenie' do
            dbs = DatabaseService.new Sequel.sqlite
            g = Grade.new
            expect(g).to be_instance_of Grade
        end
    end
end