require File.join($__lib__,'Example2')

class Exmaple2Test < Minitest::Test
	def setup
		@ex = Example2.new
	end
	def test_one
		assert 1 == @ex.get_one
	end
	def test_zero
		assert 0 == @ex.get_zero
	end
end