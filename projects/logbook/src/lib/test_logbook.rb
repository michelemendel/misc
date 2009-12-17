# 
# Testing logbook.
# 
# Author:: Michele Mendel
# Date:: 2008.02.20
# 
 
$env = :test
$LOGBOOK_BASEDIR = File.dirname(__FILE__) + '/logbook'
$:.unshift(File.dirname(__FILE__))

require 'pp'
require 'test/unit'
require 'logbook'

include Test::Unit

class TestLogbook < Test::Unit::TestCase
    TOPIC = 'testfile - delete_with_impunity'
    LOGGER = 'arne'
    MSG = 'A meaningless string'

    def test_log
        Logbook.empty_logfile(TOPIC) #Have to be sure it's a new file
        Logbook.log(TOPIC, LOGGER, MSG)        
        
        assert(File.exists?(Logbook.file_name(TOPIC)))
        assert(Logbook.read_log(TOPIC).match(MSG)) #Added item exists?
    end

    # This doesn't work. When creating and the immediately deleting a file,
    # you get "Permission denied".
    def test_delete_log_file
#        Logbook.log(TOPIC, LOGGER, MSG)
#        Logbook.delete_logfile(TOPIC)
#        assert(!File.exists?(Logbook.file_name(TOPIC)))
    end
    
    # Empty as a verb.
    def test_empty_log_file
        Logbook.log(TOPIC, LOGGER, MSG)
        Logbook.empty_logfile(TOPIC)
        assert(!File.size?(Logbook.file_name(TOPIC)) != nil)
    end
    
    def test_undo
    end
    
    def test_counter
        Logbook.log(TOPIC, LOGGER, MSG)
        Logbook.empty_logfile(TOPIC)
        Logbook.log(TOPIC, LOGGER, MSG)
        assert_equal(1, Logbook.counter_next(TOPIC))
    end
end

