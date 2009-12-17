require 'getoptlong'

ip = nil
machine = nil
useIP=false

def printHelp
puts <<-HELP
Usage:
	program blah blah

Options:
	--ip|-i\t\tIP address
	--machine|-N\tmachine name
	--help|-h\tthis text
HELP
end

opts = GetoptLong.new(
			[ '--ip',   		'-i', 	GetoptLong::OPTIONAL_ARGUMENT ],
            [ '--machine',  	'-m', 	GetoptLong::OPTIONAL_ARGUMENT ],
            [ '--help',     	'-h', 	GetoptLong::NO_ARGUMENT			]
		)

begin
	opts.each do |opt, arg|
		puts(opt +" : "+arg)
		case opt
		when '-'
			printHelp
			exit 1
		when '--help' | '-'
			printHelp
			exit 1
		when '--ip'
			ip = arg
			useIP=true
		when '--machine'
			machine = arg
			useIP=false
		end
	end
rescue => err
	printHelp
	exit
end


if useIP
	puts("IP " + ip)
else
	puts("machine " + machine)
end



