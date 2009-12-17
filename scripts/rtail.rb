#
# Does remote tail using the Net::SSH library.
#
# Author:: Michele Mendel
# Date:: Oslo 2005-09-28
# Version:: 0.1
#
# Specification:
# * get all active log files (log files ending with .log)
# * show them in a numbered list
# * user selects one file
# * start tailing file (tail -f)
#
# see:: http://net-ssh.rubyforge.org/
#
require 'yaml'
require 'pp'
require 'net/ssh'

include Net


#
class Session
    attr_reader :name, :host, :un, :pw, :session
    
    @@am = %w(password keyboard-interactive)
    
    def initialize(name, host, un, pw)
        @name = name
        @host = host
        @un = un
        @pw = pw
        @session = Net::SSH.start(host, un, pw, :auth_methods => @@am)
    end
        
    def close
        @session.close
    end
end

#
class Dir
    attr_reader :name, :session, :dir, :logs
    
    def initialize(name, session, dir)
        @name = name
        @session = session
        @dir = dir
        @logs = []
        init_active_logs
    end
    
    def init_active_logs
        @session.session.open_channel do |channel|
            channel.on_data do |ch, files|
                files.gsub!(/^.+\//, "")
                active_logs = files.split("\n")
                active_logs.each{|al|
                    log = Logfile.new(AutoIncrement.getNext, al, @dir, @session)
                    @logs << log
                }
            end
            channel.exec("ls -la #{@dir}*.log")
        end
        @session.session.loop
    end
    
    def list_active_logs
        puts "#{@session.name}.#{@name} @ #{@session.host}"
        puts @dir
        
        @logs.each {|log|
            printf("%-4s %-s\n", log.id, log.name)
        } unless @logs==nil        
    end
end

#
class Logfile
    attr_reader :id, :name, :dir

    def initialize(id, name, dir, session)
        @id = id
        @name = name
        @dir = dir
        @session = session
    end
    
    def tail
        puts "----- tail -f #{@name} -----\n\n"
        
        @session.session.open_channel do |channel|
            channel.on_data do |ch, data|
                puts data
            end
            channel.exec "tail -f #{@dir}#{@name}"
        end
        @session.session.loop
    end    
end

#
class Logs
    attr_reader :dirs
    
    def initialize(properties)
        @properties = YAML.load(File.open(properties))
    end
    
    #
    def show_logfiles
        @dirs = []
        session = get_session
        @environment["dirs"].each {|dir_name, dir|
            @dirs << Dir.new(dir_name, session, dir)
        }

        @dirs.each{|logdir|
            logdir.list_active_logs
            puts
        }
    end
    
    #
    def tail(id)
        selected_id = id.to_i
        @dirs.each{|logdir|
            logdir.logs.each{|log|
                if(log.id==selected_id)
                    log.tail
                    break
                end
            }
        }
    end
    
    def get_session()
        Session.new(@environment[:name],
                    @environment["host"],
                    @environment["un"], 
                    @environment["pw"])  
    end
    
    #
    def select_file()
        show_logfiles
        
        print "Which file to tail? "
        id = gets
        puts
        tail(id)
    end
    
    #
    def select_environment
        envs = []
        idx = 1
        @properties.each_key{ |env_name|
            envs << env_name
            printf("%-4s %-s\n", idx, env_name)
            idx += 1
        }
        print("\nSelect environment: ")
        env_id = gets
        env = envs[env_id.to_i-1]
        @environment = {:name => env}
        @environment.merge!(@properties[env])
    end

end

# Getting unique numbers for the list of files
class AutoIncrement
    @@counter = 0
    def self.getNext
        @@counter += 1
    end
end



# Run app
local_dir = File.dirname(__FILE__)
properties = local_dir + "/rtails_props.yml"

logs = Logs.new(properties)
logs.select_environment
logs.select_file



