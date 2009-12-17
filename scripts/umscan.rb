
#
# User logged on to which machine scanner
#
# usage: umscan -i f-t.f-t.f-t.f-t
# f-from, t-to
# ex: usage: umscan -i 148.121.0-2.0-255
#

require 'pp'
require 'optparse'
require File.dirname(__FILE__)+'/ipaddresses'

# Arguments
# ------------------------------------
ARGV.options {  |opt|
	opt.banner << " argv..."
	opt.on("Options:")
	opt.on("-i IP NUMBER", String, "Give an ip number: ") { |@ip|}
	opt.on("--help", "-h", "This text") {
		puts opt
		exit 0
	}

	if(ARGV.length==0)
		puts opt
		exit 0
	end

	begin
		@ret = opt.parse!
	rescue => err
		puts err
		puts opt
		exit 0
	end
}


# Starting scan
# ------------------------------------
puts "\n----- STARTING SCRIPT -----"

iag = IpAddressGen.new(@ip)
puts "Scanning #{@ip}"
puts "nof ip addresses to scan: #{iag.getNofAddresses}"
puts
start = Time.now
iag.eachIP{ |ip|
	puts "\nscanning #{ip}"
	nbtscanRet = `nbtscan #{ip}`.to_a

	nbtscanRet.each_index{ |idx|
		puts "#{nbtscanRet[idx]}"
		#~ match = reUser.match(nbtscanRet[idx])
		#~ if(match)
			#~ puts match[1]
		#~ end
	}
}

puts "\nit took #{Time.now-start} ms"
puts "\n----- END OF SCRIPT -----"



