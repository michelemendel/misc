
#-------------------------------------------------------------------------
class SongList
	def initialize
		@songs = Array.new
		@index = WordIndex.new
	end
  
	def append(aSong)
		@songs.push(aSong)
		@index.index(aSong, aSong.name, aSong.artist)
		self
	end
	
	def lookup(aWord)
		#puts "----> SongList.lookup: before"
		@index.lookup(aWord)
		#puts "----> SongList.lookup: after"
	end

	#def [](key)
	#	return @songs[key] if key.kind_of?(Integer)
	#	return @songs.find { |aSong| aSong.name == key }
	#end
	
	def showIndex
		@index.showIndex
	end

	def showWordIndex
		puts @index
	end

end

#-------------------------------------------------------------------------
class WordIndex
	attr_reader :index

	def initialize
		@index = Hash.new(nil)
	end
  
	def index(anObject, *phrases)
		phrases.each do |aPhrase|
			aPhrase.scan /\w[-\w']+/ do |aWord|   # extract each word
				aWord.downcase!

				if @index[aWord].nil?
					#puts "#{aWord} is nil"
				end
				
				@index[aWord] = [] if @index[aWord].nil?
				@index[aWord].push(anObject)
				#@index[aWord] = anObject
			end
		end
	end
	
	def lookup(aWord)
		#puts "----> WordIndex.lookup: before"
		@index[aWord.downcase]       #.each { |x| print "---", x, "\n" }
		#puts "----> WordIndex.lookup: after"
		
	end
	
	def showIndex
		@index.each { |key, value| puts "#{key}: #{value}"}
	end
		
	def to_s
		"WordIndex"
	end
end

#-------------------------------------------------------------------------
class Song
	attr_reader :name, :artist, :duration
	
	def initialize(name, artist, duration)
		@name     = name
		@artist   = artist
		@duration = duration
	end

	def to_s
		#puts "----> Song.to_s"
		"Song: #{@name}--#{@artist}" # (#{@duration})"  
	end  
end


# TEST--------------------------------------------------------------------
songFile = File.open("songfile.txt")
songs = SongList.new

songFile.each do |line|
  file, length, name, title = line.chomp.split(/\s*\|\s*/)
  name.squeeze!(" ")
  mins, secs = length.scan(/\d+/)
  songs.append (Song.new(title, name, mins.to_i*60+secs.to_i))
end

puts songs.lookup("one")
puts songs.lookup("first")

#songs.showIndex
#songs.showWordIndex