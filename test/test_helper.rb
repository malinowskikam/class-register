$__lib__ = File.join(__dir__,'..','lib')
require "minitest/autorun"

#modyfikuje standardowy output minitest
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

#uruchamia wszystkie testy w plikach *rb z katalobu /minitest/
Dir[File.join(__dir__, 'minitest','*.rb')].each do |file| 
	require file 
end