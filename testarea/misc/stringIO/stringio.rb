require 'pp'
require 'stringio'

s = StringIO.new <<-EOY
	.. string to read from here ..
	sadsadsa
	1234
	HEllO
EOY


# FILE

#~ Writing to a file
out = StringIO.new('/MM/Dev/Ruby/testarea/stringIO/outtext.txt','a+')
s.readlines.each do |line|
	puts line
	out.write(line)
end
out.flush
#~ out.readlines.each { |k| putsx k.linenox }

#~ Reading from a file
#~ input = StringIO.new("hello.txt", 'r')
#~ input.readlines.each do |line|
	#~ puts line 
#~ end


# STRING

#~ Writing to a string
#~ s2 = StringIO.new
#~ s.readlines.each do |line|
	#~ puts line 
	#~ s2.write( line )
#~ end

#~ s2.readlines.each do |line|
	#~ pp line 
#~ end
