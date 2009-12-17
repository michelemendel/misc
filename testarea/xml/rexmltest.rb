require "rexml/document"

include REXML

def removeComment(xmlfile)
	xmlfile.gsub!(/<!.*?>/, '')
	xmlfile.gsub!(/^---.*$/, '')
end

start = Time.now

#~ xmlfile = File.new("./testxml/build.xml").read
xmlfile = File.new("/MM/Dev/Ruby/scripts/mm/file.xml").read
#~ xmlfile = File.new("build2.xml").read
#~ puts xmlfile

#~ removeComment(xmlfile)
#~ puts xmlfile

puts
puts "Reading xml file"
doc = Document.new(xmlfile)
puts "Processing file."

doc.elements.each("//") { |element|
	#~ print element
	print '.'
	#~ print element.attributes["name"] + "\n"
	#~ depends = element.attributes["depends"]
	#~ if(depends)
		#~ print "\t" + element.attributes["depends"]  + "\n"
	#~ end
}

puts
all_elements = doc.elements.to_a("//")
puts all_elements.length

#~ xml = ""
#~ output = File.open('build2.xml', 'w')
#~ doc.write($stdout)
#~ doc.write(output)

puts "\n#{Time.now-start} ms"
