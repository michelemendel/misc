# From http://www.rubygarden.org/ruby?OneLiners

require 'socket'

ARGV[1].to_i.upto(ARGV[2].to_i) {|x|
	puts "Testing #{x}"
	puts x if (TCPSocket.new(ARGV[0],x) rescue false)  
}
