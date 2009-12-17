require 'net/ftp'
include Net

# 
# remotetail.rb - Remote tail with ftp
# version: 1.0
# date: 2004.03.26
# location: Oslo, Norway
#
# author: Michele Mendel 
# mail: mmendel@online.no
# mail: michele.mendel@telenor.com
#
# Description:
# This application uses ftp to repeatedly retrieve a file,
# and prints the new lines.
# Since it usually takes more than a second to retrieve the file,
# I'm not using sleep.
#


class RemoteTail

	def initialize(host, un, pw, dir, filePattern)
		@host = host
		@un = un
		@pw = pw
		@directory = dir
		@filePattern = filePattern

		login
		init
	end

	def tail(fileArray, linePos, newLinePos)
		linePos = newLinePos - 10 if(linePos == 0 || linePos == nil)
		nofLines = newLinePos - linePos
		content = fileArray.reverse[0..nofLines-1].reverse
		return content, nofLines
	end


	def getFileInfo(filename)
		fileArray = IO.readlines(filename)
		return fileArray, fileArray.size
	end

	def login
		print "Trying to log in to host #{@host}"
		@ftp = FTP.open(@host, @un, @pw)
		print " - logged in\n"
	end
	
	def init
		puts "Changed directory to #{@directory}"
		files = @ftp.chdir(@directory)
        @file = @ftp.nlst(@filePattern)[0]
		print "Logfile: #{@file}\n\n"
	end
	
	def start
		@linePos = 0
		loop {
			starttime = Time.now
			@ftp.gettextfile(@file, @file)
			#~ print "Time to retrieve file: #{Time.now - starttime} sec"
		
			@size = File.size(@file)
			
			if(@tmpSize != @size)
				@tmpSize = @size
				@mtime = File.mtime(@file)
				content, newLinePos = getFileInfo(@file)
				tailContent, nofLines = tail(content, @linePos, newLinePos)
				print "\nChanged file retrieved at #{@mtime}\n"
				print "nof lines / current line pos: #{nofLines} / #{newLinePos}\n\n"
				print tailContent, "\n"
				@linePos = newLinePos
				#sleep @sleeptime
			else
				#~ print ": file not changed\n"
			end
		}
	end
	
	def logout
		ftp.close
	end
end






