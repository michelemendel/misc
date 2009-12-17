require 'net/ssh'
require 'net/sftp'
require 'pp'

include Net

server = 'ast-wt01'
un = 'nupo'
pw = 'nupo2004'
dir = '/home/cosmos/cos/releases/domain_Cos17/current_release/CM1/logs/'

SSH.start(server, un, pw) do |ssh|
    pp ssh.list
    ssh.sftp.connect do |sftp|
        # pp sftp.methods.sort
        # Dir.foreach('.') do |file|
            # puts file
        # end
    end
end