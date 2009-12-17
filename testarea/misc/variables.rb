
class MyClass
	@@cv = 0 #class variable
	#@icv #instance class variable
	Con = 222
	
	def MyClass.cv=(v)
		@@cv = v
	end
	
	def MyClass.cv
		@@cv
	end

	def MyClass.icv=(v)
		@icv = v
	end

	def MyClass.icv
		@icv
	end
	
	def icv=(v)
		@icv = v
	end

	def icv
		@icv
	end
	
	def cv=(v)
		@@cv = v
	end

	def cv
		@@cv
	end
	
	def Con
		Con
	end
	def MyClass.Con
		Con
	end
	
end


c1 = MyClass.new
c2 = MyClass.new

puts "---- test 1"
p c1.icv
p c2.icv
p MyClass.icv
p MyClass.cv
p c1.cv
p c1.Con
p MyClass.Con


puts "---- test 2"
c1.icv = 9
p c1.icv
p c2.icv
p MyClass.icv
p MyClass.cv
p c1.cv

puts "---- test 3"
MyClass.icv = 43
MyClass.cv = 987
p c1.icv
p c2.icv
p MyClass.icv
p MyClass.cv
p c1.cv

puts "---- test 3"
c1.cv = 654
p c1.icv
p c2.icv
p MyClass.icv
p MyClass.cv
p c1.cv




















