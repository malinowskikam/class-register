require File.join($__lib__,'Example2')

describe 'Example2 Tests' do
	let(:ex) do
		Example2.new
	end
	
	it 'Get one' do
		expect(ex.get_one).to eq 1
	end
	
	it 'Get zero' do
		expect(ex.get_zero).to eq 0
	end	
end