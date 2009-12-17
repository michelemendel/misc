require 'remotetail'

# 
# rtail.rb - shell client to remotetail.rb
# v1.0, 2004.03.26, Oslo, Norway
#
# author Michele Mendel 
# (mmendel@online.no, michele.mendel@telenor.com)
#
# see 
# http://www.oreilly.com/catalog/ruby/chapter/ch04.html
# http://net-ssh.rubyforge.org/chapter-4.html
#


thisprog = File.basename($0, ".rb")

def getNextArg
	ARGV.shift
end

@usage = <<-ENDUSAGE
usage:

#{thisprog} <server> <user> <password> <dispatcher>

<server> can be [prod | sys]: production or systemtest

<dispatcher> can be [NRDB | Oqnrdb | NetworkService | NumportS212]: It's enough to write the first two letters
ENDUSAGE

if(ARGV.length != 4)
	print @usage
	exit
elsif
	server 		= getNextArg
	un 			= getNextArg
	pw 			= getNextArg
	dispatcher 	= getNextArg
end

case dispatcher.downcase
	when /nr.*/
		filepattern = "NRDBDispatcher.2*.log"
	when /oq.*/
		filepattern = "OqnrdbDispatcher.2*.log"
	when /ne.*/
		filepattern = "NetworkServiceDispatcher.2*.log"
	when /nu.*/
		filepattern = "NumportS212Dispatcher.2*.log"
	else
		print @usage
		exit
end

case server.downcase
	when 'sys'
		host = 'ast-wt01'
		dir = '/home/cosmos/aux/daemon/log'
	when 'prod'
		host = 'asp-cosmos02'
		dir = '/progs/cosmos/aux/daemon/log'
	else
		print @usage
		exit
end

#~ puts host, un, pw, dir, filepattern

rt = RemoteTail.new(host, un, pw, dir, filepattern)
rt.start
