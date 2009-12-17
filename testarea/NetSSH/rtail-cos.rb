require 'net/ssh'

include Net

#
# http://net-ssh.rubyforge.org/
#


$host_test = 'ast-wt01'
$pw = $un = 'cosmos'
$dir_daemon = '/home/cosmos/aux/daemon/log'
$dir_cos    = '/home/cosmos/cos/releases/domain_Cos17/current_release/CM1/logs/'


def print_filename(file)
    puts "-"*80
    printf("#{" "*30}%-20s\n", File.basename(file))
    puts "-"*80

end

def rtail(session, file)
    session.open_channel do |channel|
        channel.on_data do |ch, data|
            print_filename(file)
            puts data
        end
        channel.exec("tail -f #{file}")
    end
end

def start_session(host, un, pw, dir)
    am = %w(password keyboard-interactive)

    SSH.start(host, un, pw, :auth_methods => am) do |session|
        rtail(session, "#{dir}CM1.log")
        rtail(session, "#{dir}audit.log")
        rtail(session, "#{dir}error.log")
        rtail(session, "#{dir}access.log")
        rtail(session, "#{dir}edc-audit.log")
        rtail(session, "#{dir}performance.log")
        rtail(session, "#{dir}proffnet.log")
        rtail(session, "#{dir}queuebridge.log")
        rtail(session, "#{dir}report.log")
        rtail(session, "#{dir}simnum.log")
        session.loop    
    end
end

start_session($host_test, $un, $pw, $dir_cos)