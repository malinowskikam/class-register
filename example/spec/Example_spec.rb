require File.join($__lib__,'Example')

describe 'Example Tests' do
	let(:ex) do
		Example.new
	end
	
	it 'Get true' do
		expect(ex.get_true).to be true
	end
	
	it 'Get false' do
		expect(ex.get_false).to be false
	end	
end