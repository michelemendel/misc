

class Test
	attr_accessor :test
	def printMe
		@test = 10
		puts "Hello"
	end
end

t = Test.new
t.printMe
puts t.test

class Test
	def printMe
		@test = 42
		puts "Goodbye"
	end
end

t.printMe
puts t.test

#~ gets










