# 
# Testing topics.
# 
# Author:: Michele Mendel
# Date:: 2008.02.20
# 
 
$env = :test
$LOGBOOK_BASEDIR = File.dirname(__FILE__) + '/logbook'
$:.unshift(File.dirname(__FILE__))

require 'pp'
require 'test/unit'
require 'topics'

include Test::Unit

class TestTopics < TestCase
    def add_and_assert
        topic = 'test_add_topic'
        Topics.add(topic)
        topics = Topics.read
        assert(topics.include?(topic))
        # Cleanup
        Topics.delete(topic)        

    end
    
    def remove_and_assert
        topic = 'test_remove_topic'
        Topics.add(topic)
        Topics.delete(topic)
        topics = Topics.read
        assert(!topics.include?(topic))
    end
    
    def test_add_to_non_existing_topics_file
        Topics.delete_file
        add_and_assert
    end

    def test_add_to_empty_topics_file
        Topics.delete_all_topics
        add_and_assert
    end
    
    def test_delete_from_non_existing_topics_file
        Topics.delete_file
        remove_and_assert
    end
    
    def test_delete_from_empty_topics_file
        Topics.delete_all_topics
        remove_and_assert
    end
    
    def test_list_topics
        assert_kind_of(Array,Topics.list)
    end
    
end

