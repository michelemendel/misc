require 'optparse'
require 'pp'


ARGV.options {  |opt|

	opt.banner << " argv..."

	opt.on("Options:")
	opt.on("--ip", "-i [IP NUMBER]", "Give an ip number") { |@ip| @ip ||= '127.0.0.1'}
	opt.on("--machine", "-m MACHINE NAME", String, "Give machine name") { |@machine| }
	opt.on("--help", "-h", "This text") {
		puts opt
		exit 0
	}
	opt = opt.parse
	#~ exit 0
	puts "here"
}


if @ip
	puts("IP " + @ip)
else
	puts("machine " + @machine)
end

#~ puts "This is the end"