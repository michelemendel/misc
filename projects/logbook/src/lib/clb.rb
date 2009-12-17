# 
# clb = Console LogBook
# 
# Author:: Michele Mendel
# Date:: Oslo 2008-02-21
# 
# # see:: http://www.erikveen.dds.nl/rubyscript2exe/
# 

require 'rubyscript2exe'
$LOGBOOK_BASEDIR = RUBYSCRIPT2EXE.exedir + '/logbook'

require 'pp'
require 'logbook'

exit if RUBYSCRIPT2EXE.is_compiling?

def usage
    puts "USAGE:"
    puts "cl <logger> <topic> - (Console Log) Start console application with user and topic"
    puts "\nCOMMANDS"
    puts ":ct <topic> - Change topic (case insensitive)."
    puts ":lt         - List all topics"
    puts ":sl         - Show current log"
#    puts ":gr <text>  - grep for text in current topic"
#    puts ":u          - Undo last entry"
    puts ":dir        - Directory of log files and topics file"
    puts ":h          - Show this help"
    puts ":q          - Quit"
end

if(ARGV.size != 2)
    usage 
    exit
end
@logger = ARGV[0]
@topic = ARGV[1]
puts "Welcome #{@logger}. Topic is #{@topic}"
ARGV.clear

#Start loop
loop do
    msg = gets.chomp.strip
    case msg
    when /^:ct/i
        @topic = msg.match(/^:ct *(\w+)/)
        if(@topic.nil?)
            puts "Did you forget to enter a topic?"
        else
            @topic = @topic[1].downcase
            puts "Changed topic to #{@topic}"
        end
    when /^:lt/i
        puts Topics.list
    when /^:sl/i
        puts Logbook.read_log(@topic)
    when /^:dir/i
        puts $LOGBOOK_BASEDIR
    when /^:h/i
        usage
    when /^:q/i
        exit
    else
        unless(msg.empty?)
            Logbook.log(@topic, @logger, msg) 
#            puts "#{@topic}> #{msg}"
        else
            puts "No entry added"
        end
    end
end
