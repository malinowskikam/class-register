require File.join($__lib__,'Example')

class ExmapleTest < Minitest::Test
	def setup
		@ex = Example.new
	end
	def test_true
		assert true == @ex.get_true
	end
	def test_false
		assert false == @ex.get_false
	end
end