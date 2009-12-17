

class Fibonacci
	def Fibonacci.fib(max)
		i1, i2 = 1, 1
		while i1 <= max
			yield i1
			i1, i2 = i2, i1+i2
		end
	end
end

Fibonacci.fib(1000) {|i1| print i1 , " "}
print "\n"

