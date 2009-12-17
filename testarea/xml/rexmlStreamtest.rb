require "rexml/document"
require "rexml/streamlistener"

include REXML

class MyListener
	include StreamListener
	attr_accessor(:path)

	def pushPath(newentry)
		@path = @path?@path + '/' + newentry:newentry
	end

	def popPath
		@path = @path.sub(/\/[\w\s-]*$/, '') if @path
	end

	def curPath
		@path
	end

	def tag_start(name, attrs)
		#~ puts "tag_start: #{name}"
		#~ pushPath(name)
		#~ print '.'
		#~ p curPath

		#~ if(name=='target')
			#~ @attrs = attrs
			#~ printAttrs('name')
			#~ printAttrs('depends')
		#~ end

		#~ if(name=='echo')
			#~ @attrs = attrs
			#~ printAttrs('name')
			#~ printAttrs('depends')
		#~ end
	end


	def tag_end(name)
		#~ puts "tag_end: #{name}"
		#~ popPath
		#~ p curPath
	end


	def text(x)
		#~ puts "x: #{x}"
	end

	def printAttrs(attrName)
		if(attr = @attrs.assoc(attrName))
			attr.each_index{ |idx|
				print attr[idx] + ": " if idx==0
				print attr[idx] unless idx==0
			}
			puts
		end
	end

end


start = Time.now
puts "START"

source = File.new("masterreport.xml")
#~ source = File.new("build2.xml")
listener = MyListener.new
REXML::Document.parse_stream(source, listener)


puts "\n#{Time.now-start} ms"
puts "END"
