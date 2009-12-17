require 'pp'
require 'open-uri'

@host = "http://minusdrums.com/"
#~ @dir = "C:/DownloadTmp/minus_music_previews"
@dir = "C:/mm/drumming/minus_music_previews"
<<<<<<< HEAD:scripts/drumless/minusdrums/minusdrums_reviews.rb
@dir = "C:\\mm\\Dev\\rubydev\\scripts\\drumless\\minusdrums/minus_music_previews"
=======
@dir = "D:\\MM\\Dev\\rubydev\\scripts\\drumless\\minusdrums\\minus_music_previews"
>>>>>>> 571cb01db5de8584b4d9db627b7be71aaecdbdcf:scripts/drumless/minusdrums/minusdrums_reviews.rb
#~ @dir = "minus_music_previews"

def category_urls
	url = @host + "joomla/index.php?option=com_content&task=section&id=6&Itemid=29"
	re = /sectionid=6&amp;id=(\d+)&amp;Itemid=29" class="category">[\n\t]*(.+?)<\/a>/m
	page = open(url).read
	page.scan(re)
end

def song_urls(id)
	url = @host + "joomla/index.php?option=com_content&task=category&sectionid=6&id=#{id}&Itemid=29"
	re = /<b><u>(.+?)<\/u><\/b> <a href=.*?task=preview&id=(\d+)">\(Preview\)<\/a>/m
	#~ re = /sectionid=6&amp;id=(\d+)&amp;Itemid=29" class="category">[\n\t]*(.*?)<\/a>/m
	page = open(url).read
	page.scan(re)
end

def save_song(id, filename)
	filename.tr!('/','_')
	filename = File.join(@dir,filename)
	if(File.exists?(filename))
		puts "#{filename} already exists"
	else
		path = "joomla/index.php?option=com_downloadmgr&task=preview&id=#{id}"
		src = open(@host+path).read	
		puts "Saving #{filename} (#{path})"
		File.open(filename,"wb").write(src) 
	end
end

#~ save_song("257", "Jazz - 5/4 Jazz Tune - Jazz.mp3")
#~ save_song("257", "XXXXXX-Jazz.mp3")
#~ exit

start = Time.now

Dir.mkdir(@dir) unless File.exists?(@dir)

category_urls.each do |cat|
	song_urls(cat[0]).each do |song|
		fn = cat[1] + " - " + song[0] + ".mp3"
		save_song(song[1], fn)
	end
end

puts "Songs saved in #{@dir}"
puts "It took #{Time.now-start} seconds"

