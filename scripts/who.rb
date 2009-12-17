require 'pp'
require 'optparse'

ARGV.options {  |opt|
	opt.banner << " argv..."
	opt.on("Options:")
	opt.on("--ip", "-i IP NUMBER", "Give an ip number") { |@ip| @ip ||= '127.0.0.1'}
	opt.on("--machine", "-m MACHINE NAME", String, "Give machine name") { |@machine| }
    opt.on("--verbose", "-v VERBOSE RESULT", TrueClass, "Includes full result from 'net user /domain ...'") { |@verbose| }
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

#~ ip = '148.121.149.211'
#~ machine = 'TNA-FBU-02-3217'
#~ machine = 'TNA-FBU-02-5387'
#~ ip = '148.121.152.29'
#~ machine = 'TNA-FBU-02-3458'
#~ machine = 'TNA-FBU-02-4104'
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

reMachineOrUser = /^\s*([\w\d-]*).*<\d\d>\s*unique.*?Registered/i
reFullName  = /^\s*Full Name\s*([\w\s]*)/i

if(@ip)
	nbtstat = `nbtstat -A #{@ip}`.to_a
else
	nbtstat = `nbtstat -a #{@machine}`.to_a
end

# --- Getting machine name and user name
machineOrUser = []
nbtstat[8..-1].each{ |v|
    match = reMachineOrUser.match(v)
    machineOrUser.push(match[1]) unless match==nil
}

# --- Full Name
machineOrUser.each{ |mou|
    puts "----- Testing #{mou} -----"
    # system("net user /domain #{mou}")
    netuser = `net user /domain #{mou}`
	if($?==0)
		fullName = reFullName.match(netuser)[1]
	end
    unless(fullName==nil)
        puts "------------------------------\n\n"
        puts "RESULT\n\n"
        puts "#{mou} is #{fullName}\n"
        puts "IP address: #{@ip}\n"
        puts "Machine: #{@machine}\n"
        puts ""
        puts "------------------------------\n\n"
        if(@verbose)
            puts "FULL RESULT\n\n"
            puts netuser
            puts "------------------------------\n"
        end
    end	
}



