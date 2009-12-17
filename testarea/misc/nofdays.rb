require 'date'  

d1 = Array.new
d2 = Array.new

d1[0] = Date.new(2001, 9, 11)
d2[0] = Date.new(2001, 12, 31)  

d1[1] = Date.new(2001, 12, 31)
d2[1] = Date.new(2002, 12, 31)  

d1[2] = Date.new(2002, 12, 31)
d2[2] = Date.new(2003, 12, 31)  

d1[3] = Date.new(2003, 12, 31)
d2[3] = Date.new(2004, 3, 11)  


from = Date.new(2001, 9, 11)
to = Date.new(2004, 3, 11)  


sum = 0
d1.each_index { |i|
	sum += d2[i]-d1[i]
	puts "subdif = #{d2[i]-d1[i]}"
}

puts "Sum from subs = #{sum}"
puts "Sum = #{to-from}"



d1 = Date.new(2001, 9, 11)
d2 = Date.new(2001, 9, 12)  
dif1 = d2-d1
puts dif1
