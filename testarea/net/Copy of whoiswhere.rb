require 'getoptlong'
require 'pp'


usage= <<-'ENDTEXT'
This program finding a logged in user.
usage:
whoiswhere [--ip|-i] ip number
or
whoiswhere [--machine|-m] machine name
ENDTEXT


opts = GetoptLong.new(
  [ "--ip",    "-i",            GetoptLong::OPTIONAL_ARGUMENT ],
  [ "--machine", "-m",       GetoptLong::OPTIONAL_ARGUMENT ]
)

useIp = true
ip = "127.0.0.1"
machine = ""

begin
	opts.each do |opt, arg|
		if (opt=="--ip")
			puts "IIIIIIPPPPPPPPP"
			ip = arg
			useIp = true
		elsif (opt=="--machine")
			puts "MAAAAAAACCCCCHINE"
			machine = arg
			useIp = false
		end
	end
	raise if opts.get==nil
rescue
	puts usage
	exit
end






# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#~ ip = '148.121.149.211'
#~ machine = 'TNA-FBU-02-3217'
#~ machine = 'TNA-FBU-02-5387'
#~ ip = '148.121.152.29'
#~ machine = 'TNA-FBU-02-3458'
#~ machine = 'TNA-FBU-02-4104'


# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


reMachineOrUser = /^\s*([\w\d-]*).*?Registered/i
reFullName  = /^\s*Full Name\s*([\w\s]*)/i

if useIp
	puts "Using ip #{ip}"
	#~ nbtstat = `nbtstat -A #{ip}`.to_a
else
	puts "Using machine #{machine}"
	#~ nbtstat = `nbtstat -a #{machine}`.to_a
end

#~ puts nbtstat
#~ puts "++++++++++++++++++++++++"

# Getting machine name and user name
#~ puts "Machines or User?"

#~ machineOrUser = []
#~ nbtstat[8..-1].each{ |v|
	#~ match = reMachineOrUser.match(v)
	#~ machineOrUser.push(match[1]) unless match==nil
#~ }
#~ puts machineOrUser

# Full Name

#~ machineOrUser = 'TNA-FBU-02-3217'
#~ machineOrUser.each{ |mou|
	#~ puts "----- Testing #{mou} -----"
	#~ netuser = `cmd.exe /c net user /domain #{mou}`
	#~ netuser = system("net user /domain #{mou}")
	#~ if($?==0)
		#~ fullName = reFullName.match(netuser[4])[1]
	#~ end
	#~ puts ret
#~ }

#~ puts "THE END"



