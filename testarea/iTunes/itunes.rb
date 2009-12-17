# 
# === Extracting data from iTunes XML file
#
# Description:
# Use this program to extract data, or to 
# create a tree view from iTunes XML file.
#
# Version:: 1.0
# Date:: 2004.04.30
# Location:: Oslo, Norway
#
# Author:: Michele Mendel 
# Mail:: mmendel@online.no
# Mail:: michele.mendel@telenor.com
# License::  Copyright (c) 2004 Michele Mendel.
#
#

require 'arrayExtension'
require 'pp'
require 'cgi'
require 'iTunesKeys'

class ITunesParser
    include Keys
    
    RE_LINE = Regexp.new('<key>(.*)<\/key><.*>(.*)<\/.*>')
    
    def initialize(file)
        @file = file
        @songlist = []
        @songObject = Song.new(0)
    end

    def parse
        IO.foreach(@file){|line|
            if(match = RE_LINE.match(line))
                handleSong(match[1], match[2])
            end
        }
        @songlist
    end
    
    def handleSong(key, value)
        @curSong = getSongObject(value) if(key == NEW_SONG)
        @songlist.push(@curSong) if(key == END_SONG)
        
        if(KEYS.has_key?(key))            
            unescapedValue = CGI.unescapeHTML(value)
            setValue = "@curSong.#{KEYS[key]} = %<#{unescapedValue}>"
            eval(setValue)
        end
    end

    def getSongObject(id)
        ret = @songObject.clone
        ret.id = id
        return ret 
    end

end # class ITunesParser

#
class Song
    include Keys
    
    attr_accessor(:id)
    KEYS.each_value{|v| attr_accessor(v)}

    def initialize(id)
        @id = id
        KEYS.each_value {|value| eval("@#{value} = '-'")}
    end

    def to_s
        res = ''
        instance_variables.each{|v|
            res += "#{v}=#{instance_eval(v)}\n"
            res.sub!('@','')
        }
        res += "\n"
        res
    end
end # class Song

#
class Songlist
    attr_accessor :songs
    
    def initialize(iTunesFile='')
        @songs = []
        if(iTunesFile!='')
            parser = ITunesParser.new(iTunesFile)
            @songs = parser.parse
        end
    end
    
    def getValues(key)
        vals = []
        keyval = ''
        @songs.each{|s|
            keyval = getKeyval(s, key)
            vals.push(keyval)
        }
        vals.uniq.sort
    end
    
    def eachValue(key)
        vs = getValues(key)
        vs.each{|val| yield val}
    end
    
    def getSongs(key='', value='')
        return self if(key=='' && value=='')
        
        ret = Songlist.new
        @songs.each{|s|
            keyval = getKeyval(s, key)
            if(keyval == value)
                ret.songs.push(s)
            end
        }
        ret
    end
    
    def eachSong(key='', value='')
        getSongs(key, value).songs.each{|s| yield s}
    end
    
    def getKeyval(song, key)
        begin
            #~ keyval = eval("song.#{key.intern}") # Using strings
            keyval = eval("song.#{key}")        # Using symbols
        rescue => err
            puts "Song has no attribute with this name: '#{key}'"
            return
        end
        keyval
    end
    
    def printTree(keys)
        treeViewRecursive(-1, self, keys)
    end
    
    def treeViewRecursive(pos, songs, keys)
        pos += 1
        spacer = "    " * pos
        songs.eachValue(keys[pos]){|val|
            #~ puts spacer+ "#{keys[pos]}=#{val}"
            puts spacer + val
            songsSub = songs.getSongs(keys[pos], val)
            treeViewRecursive(pos, songsSub, keys) unless pos == keys.size-1
        }

    end
    
    def size
        @songs.size
    end
    
    def to_s
        @songs.each{|s| puts s}
    end
    
    alias each eachSong
end # class Songlist


# ---------------------------------------------------------------
# ---------------------------------------------------------------


#~ require 'profile'

#~ iTunesFile = "lib.xml"
#~ iTunesFile = "liblight.xml"

puts "Starting iTunes XML program"
if(ARGV.size==0)
    puts "Missing input file"
    exit
end
iTunesFile = ARGV[0]

timeStartParser = Time.now
    songs = Songlist.new(iTunesFile)
    puts "Number of songs=#{songs.size}\n\n"
timeEndParser = Time.now

timeStartTest = Time.now
    #~ keys = %w{genre artist album song}
    #~ keys = %w{song}
    
    #~ keys = [:genre, :artist, :album, :song]
    keys = [:artist, :song]
    songs.printTree(keys)
    
    #~ songs.eachValue(:genre){|v|
        #~ puts v
    #~ }
        
timeEndTest = Time.now
puts "\nFileParserTime = #{timeEndParser - timeStartParser}"
puts "FileTestTime = #{timeEndTest - timeStartTest}"

puts "ok"


