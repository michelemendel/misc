


aorig = [1,2,3,4,5,6]
borig = [1,2,3,4,5]

arr = aorig.dup
brr = borig.dup

ax = arr.collect { 
	puts arr.length
	arr.slice!(rand(arr.length)) 
}
bx = brr.collect { rand(brr.length) }


ax.each{|x| print "#{x},"}
puts
bx.each{|x| print "#{x},"}