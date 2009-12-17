# Handles topics used in logbook.
# 
# Author:: Michele Mendel
# Date:: Oslo 2008-02-20
# 
# see:: http://log4r.sourceforge.net/
# see:: http://yaml4r.sourceforge.net/
#

require 'pp'
require 'yaml'

# We don't want to destroy the working topics file.
filename = $env == :test ? 'topics_test.yml' : 'topics.yml'
TOPICSFILE = File.join($LOGBOOK_BASEDIR, filename)

class Topics
   
    #
    def Topics.add(new_topic)
        new_topic.downcase!
        topics = Topics.read
        unless(topics.include?(new_topic))
            topics << new_topic
            Topics.write(topics)
        end
    end
    
    #
    def Topics.delete(topic)
        topics = Topics.read
        if(topics.include?(topic))
            topics.delete(topic)
            Topics.write(topics)
        end
    end
    
    # Checks to see if the topic exists.
    def Topics.exists?(topic)
        Topics.read.include?(topic.downcase)
    end
    
    # Returns the filename where topic names are stored.
    def Topics.get_topics_filename
        TOPICSFILE
    end
    
    # Returns a list (array) of all topics.
    # Essentially an alias for Topics.read.
    def Topics.list
        Topics.read
    end
    
    # Returns a list (array) of all topics.
    def Topics.read
        y = false
        if(File.exists?(TOPICSFILE))
            File.open(TOPICSFILE) do |f|
                y = YAML::load(f)
            end
        end
        return y ? y : []
    end
    
    # Writes the array of topics to file.
    def Topics.write(topics)
        open(TOPICSFILE, 'w') { |io| io.print(topics.to_yaml) }
    end
    
    # 
    def Topics.delete_file
        File.delete(TOPICSFILE) if File.exists?(TOPICSFILE)
    end
    
    #
    def Topics.delete_all_topics
        Topics.write([])
    end
end



if(__FILE__ == $0)
        
end
