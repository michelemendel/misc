require "rexml/document"
include REXML

start = Time.now

xmlfile = "/MM/Dev/Ruby/scripts/mm/file.xml"
#~ xmlfile = "/MM/Dev/Ruby/scripts/mm/tutorial.xml"
#~ puts xmlfile

puts
puts "Reading xml file"
doc = Document.new(File.new(xmlfile))
puts "Processing file"



#~ doc.elements.each("*/") { |element| 
	#~ puts element.attributes["name"] 
#~ }

doc.elements.each("//") { |element|
	print element.name + "\n"
	#~ print '.'
	#~ print element.attributes["name"] + "\n"
	#~ depends = element.attributes["depends"]
	#~ if(depends)
		#~ print "\t" + element.attributes["depends"]  + "\n"
	#~ end
}

#~ puts
#~ all_elements = doc.elements.to_a("//")
#~ puts all_elements.length

#~ xml = ""
#~ output = File.open('build2.xml', 'w')
#~ doc.write($stdout)
#~ doc.write(output)

puts "\n#{Time.now-start} ms"
