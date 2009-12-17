require "log4r"
require "ftools"
require "mm/file_addon"

include Log4r

# ---- To calculate time used
start = Time.now


# ---- Constants
input = "/jakarta-tomcat/webapps/webdav/JSPWikiData/wikipages"
output = "/jakarta-tomcat/webapps/webdav/JSPWikiData/archive"

#~ input = "/MM/Dev/Ruby/scripts/testarea/source"
#~ output = "/MM/Dev/Ruby/scripts/testarea/result"

outputLog = output + "/log"
fileLogTime = start.strftime("%Y%m%d-%H%M%S")
logfile = outputLog+"/archived_"+fileLogTime+".txt"

# ---- The string to search for. Files with string will be archived
search = /\A\s*\[deleteme\]/mi

# ---- Create necessary files if they don't exist 
File.makedirs(output) unless FileTest.exists?(output)
File.makedirs(outputLog) unless FileTest.exists?(outputLog)

# ---- Setup log4r
logConfig = {"filename" => logfile}
log = Logger.new('archive')
#~ log.add(Outputter.stdout)		# no need to waste resources printing to stdout
log.add(FileOutputter.new("archive",logConfig))

# ---- Start archiving
totFiles = 0
totFilesMoved = 0
log.info("Today is #{start}")
log.info("Moving the following files from \n\t #{input} to \n\t #{output}")
log.info "----------------------------------------"

File.eachFileContent(input) do |path,fn,fc|	
	if(fc =~ search)
		log.info(fn)
		File.move(path+fn,output)
		totFilesMoved += 1
	end
	totFiles += 1
end

log.info "----------------------------------------"
log.info "Ready moving files"
log.info "Total files in #{input}: #{totFiles}"
log.info "Total files moved = #{totFilesMoved}"
log.info "Total files NOT moved = #{totFiles - totFilesMoved}"
log.info "#{Time.now - start} seconds"


