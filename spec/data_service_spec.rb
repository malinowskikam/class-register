require File.join($__lib__,'database','data_service')

describe 'Zarządzanie danymi' do
    context 'obiekt managera' do 
        it 'utworzenie' do
            expect(DataService.new Sequel.sqlite).not_to be nil
        end
        
        it 'testowanie połączenia' do
            dbs = DatabaseService.new Sequel.sqlite
            expect(dbs.connected?).to be true
        end
    end
end