require "open-uri"

class Film24

	def initialize(baseUrl, stopMarker, startPage)
		@baseUrl = baseUrl
		@stopMarker = stopMarker
		@counter = startPage
	end

	def each(pageList)
		loop {
			@counter += 1
			@url = @baseUrl + pageList + @counter.to_s
			content = URI.parse(@url).read
			break if(!content.include?(@stopMarker))
			yield(@counter, @url, content)
		}
	end

	def saveImage(imgName, folder)
		imgUrl = @baseUrl + imgName
		content = URI.parse(imgUrl).read
		File.new(folder + imgName, "wb").puts(content)
	end

end


baseUrl = "http://film24.no/"
pageList = "Titles.asp?Pg="
stopMarker = "Finner du ikke filmen"
reStrFile = '^\s*wrTitle\((.*)\)'
startPage = 90


options = Regexp::MULTILINE | Regexp::IGNORECASE #| Regexp::EXTENDED
@reFile = Regexp.new(reStrFile, options)

f24 = Film24.new(baseUrl, stopMarker, startPage)
f24.each(pageList){|counter, url, content|
	#~ print "\n-----PAGE #{counter}:  #{url}\n"
	content.each{|line|
		#~ puts line
		md = @reFile.match(line)
		if(md)
			film = md[0]
			puts film
		end
	}


	#~ print content
	#~ print "\n----- END OF PAGE #{counter} ------"
}


#~ ----------- test

#~ page1 = URI.parse("http://film24.no/Titles.asp?Pg=1").read
#~ page100 = URI.parse("http://film24.no/Titles.asp?Pg=100").read

#~ p page1.include?(contentMarker)
#~ p page100.include?(contentMarker)

#~ print page1
