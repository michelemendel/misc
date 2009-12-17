require 'net/ftp'
include Net
 
server = 'ast-wt01'
dir = '/home/cosmos/aux/daemon/log'
dir = '/home/cosmos/cos/releases/domain_Cos17/current_release/CM1/logs'
un = 'cosmos'
pw = 'cosmos'

ftp = FTP.open(server, un, pw)
ftp.chdir(dir)

#~ list = ftp.nlst("*.gz").sort.reverse
#~ puts list

#~ list.each { |f|
    #~ puts ftp.size(f)
#~ }

puts ftp.help

ftp.close
