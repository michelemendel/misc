require 'net/ssh'

include Net

host = 'ast-wt01'
dir = '/home/cosmos/cos/releases/domain_Cos17/current_release/CM1/logs/'
un = 'cosmos'
pw = 'cosmos'

am = %w(password keyboard-interactive)

SSH.start(host, un, pw, :auth_methods => am) do |session|

    #~ input = gets
    while("q" != (input=gets.strip))
        session.process.open(input) do |command|
            command.on_success do |p|
                puts "on_success"
                #~ p.puts("ls")
            end
            
            command.on_stdout do |p,data|
                puts "on_stdout"
                puts "--> #{data}"
                #~ input = gets
                    #~ p.puts input
                #~ end
            end
            
            command.on_exit do |p, status|
                puts"on_exit"
            end
        end
    end
    
end










exit

def telnet(session)
    session.open_channel do |channel|
        input=""
        while("q" != input)
            channel.on_data do |ch, data|
                puts data
            end
            input = gets.strip
            #~ puts "x2"
            p "#{input}"
            channel.exec("ls")
        end
        #~ channel.exec("ls")
    end
end


SSH.start(host, un, pw, :auth_methods => am) do |session|
    print "#{host}>"
    telnet(session)
    session.loop
end