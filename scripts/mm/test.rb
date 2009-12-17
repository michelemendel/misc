
require "ftools"
require "file_addon"


#~ input = "/MM/Dev/Ruby/scripts/testarea/source"
#~ output = "/MM/Dev/Ruby/scripts/testarea/result"

dir = "/jakarta-tomcat/webapps/webdav/cosmosweb/COS/Numport/Forvaltning"
dir = "/MM/TNM/COS/ChangeRequests"
#~ fileName = "um3.txt"

#~ content = "innehålls\ndeklaration"

#~ puts File.getContent(input, fileName)

#~ xml = File.getAllFilesAsXML(dir)
#~ puts xml

files = File.getAllFiles(dir)
puts files

#~ Dir.foreach(dir) {|f| puts(f) unless(f=="." || f == "..") }

#~ Dir.chdir(dir)
#~ files = Dir.entries(".").sort{|x,y|
	#~ print "x: ", FileTest.file?(x), ", ", FileTest.directory?(x), ", ", x, "\n"
	#~ print "y: ", FileTest.file?(y), ", ", FileTest.directory?(y), ", ", y, "\n"
	#~ if(FileTest.directory?(x) && FileTest.file?(y))
		#~ -1
	#~ elsif(FileTest.directory?(y) && FileTest.file?(x))
		#~ 1
	#~ else
		#~ x.downcase <=> y.downcase
	#~ end
#~ }

#~ files.each{|f|  puts(f) unless(f=="." || f == "..") }


#~ File.showFiles(input)
#~ File.getFiles(input){ |file| File.write(output, file, File.getContent(input, file)) }
#~ File.getFiles(input){ |file| puts file }