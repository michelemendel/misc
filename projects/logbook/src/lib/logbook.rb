# 
# A log to manually enter events.
# 
# The application using logbook must set $LOGBOOK_BASEDIR, which is the
# directory where the log files and the topics file resides.
# 
# Author:: Michele Mendel
# Date:: Oslo 2008-01-24
# 
# see:: http://log4r.sourceforge.net/
# see:: http://yaml4r.sourceforge.net/
#


$:.unshift(File.dirname(__FILE__))

Dir.mkdir($LOGBOOK_BASEDIR) unless File.exist?($LOGBOOK_BASEDIR)

require 'pp'
require 'log4r'
require 'yaml'
require 'topics'

include Log4r

class Logbook
    #
    def Logbook.log(topic, logger, msg)
        log = Logbook.get_log(topic, logger)
        log.info(msg)
    end
    
    #
    def Logbook.get_log(topic, logger)
        topic = topic.downcase
        Topics.add(topic)

        log = Logger.new(logger)

        # Format 2007.10.01 04:16:41
        c = counter_next(topic)
        format = PatternFormatter.new(
            :pattern => "<t#{c}>%d</t#{c}> <u#{c}>%c</u#{c}> <m#{c}>%m</m#{c}>", 
            :date_pattern => "%Y.%m.%d %H:%M:%S")
        
        # Console output
                stdout = Outputter.stdout
                stdout.formatter = format
        
        # File putput
        log_config = {"filename" => file_name(topic), :trunc => false}
        fileout = FileOutputter.new('filelog', log_config)
        fileout.formatter = format
        
        # Add outputters
         log.outputters = stdout, fileout
#        log.outputters = fileout

        log
    end

    #
    def Logbook.read_log(topic)
        file_exists?(topic) do |fn|
            open(fn, 'r').read
        end
    end
    
    # You'll get a permission denied when trying to log and then immediately 
    # delete the logfile. I haven't find a solution to this problem.
    def Logbook.delete_logfile(topic)
        file_exists?(topic) do |fn|
            Topics.delete(topic)
            File.delete(fn)
        end
    end
    
    #
    def Logbook.empty_logfile(file_name)
        file_exists?(file_name) do |fn|
            File.open(fn, 'w').close
        end
    end


    
    # Returns 1 if file is empty or doesn't exists.
    # Returns nil if it can't find last count.
    def Logbook.counter_next(file_name)
        fn = Logbook.file_name(file_name)
        if(File.exists?(fn) && File.size?(fn) != nil)
            f = File.open(fn)
            f.seek(-20, IO::SEEK_END)
            f = f.read.strip!.match(/m(\d+)/)
            f[1].next if f
        else
            return 1
        end        
    end
    
    #
    def Logbook.file_exists?(file_name)
        fn = Logbook.file_name(file_name)
        if(File.exist?(fn))
            yield(fn)
        else
            puts "file #{fn} doesn't exists"
        end
    end
    
    #
    def Logbook.file_name(file_name)
        File.join($LOGBOOK_BASEDIR, file_name + ".log")
    end
    
end


if(__FILE__ == $0)

    #puts Logbook.read_logfile('submarinex')

    topic = 'work'
    logger = 'michele'
    msg = 'Hello World'
    Logbook.log(topic, logger, msg)
#    Logbook.delete_logfile(topic)
#    Logbook.empty_logfile(topic)

    #pp Logbook.counter_next(topic)
    
end
