require 'net/telnet'
include Net


@server = 'ast-wt01'
@un = 'cosmos'
@pw = 'cosmos'

@path = '/home/cosmos/aux/daemon/log'
@remoteFile = 'OqnrdbDispatcher.2005.09.02-10.20.53.log'


tn = Telnet.new(
	'Host'       => @server,
	'Timeout'    => 100,
	'Telnetmode' => true,
	'Waittime'	 => 0
) { |str| print str }


#~ tn.login(@un, @pw)
tn.login(@un,@pw) { |str| print str }

#~ tn.waitfor("cd aux")  { |str| print str }

#~ tn.cmd("date")  { |str| print str }
tn.cmd("ls")  { |str| print str }

#~ tn.close

#~ tn.cmd("tail -f " @path)  { |str| print str }










