
#
class String
	def endsWith?(str)
		self =~ /#{str}$/
	end
end

#
class File
	def File.getPath(path)
		path += "/" unless path.endsWith?("/")
	end
	
	def File.getFile(file)
		file = file.delete("/")
	end

	def File.getContent(path, fileName)
		ret = ""
		file = File.new(getPath(path) + getFile(fileName))
		if(FileTest.file?(file) && FileTest.exists?(file))
			file.read()
		end
	end

	def File.showFiles(dir)
		getFiles(dir){ |f| puts f }
	end

	def File.getFiles(dir)
		#~ if(FileTest.exists?(dir))
			#~ Dir.foreach(dir) { |f| yield(f) unless(f=="." || f == "..")}		
		#~ end
		
		Dir.chdir(dir)
		files = Dir.entries(".").sort{|x,y|
			#~ print "x: ", FileTest.file?(x), ", ", FileTest.directory?(x), ", ", x, "\n"
			#~ print "y: ", FileTest.file?(y), ", ", FileTest.directory?(y), ", ", y, "\n"
			if(FileTest.directory?(x) && FileTest.file?(y))
				-1
			elsif(FileTest.directory?(y) && FileTest.file?(x))
				1
			else
				x.downcase <=> y.downcase
			end
		}
		
		files.each{|f|  yield(f) unless(f=="." || f == "..") }
	end
	
	@spacer = ""
	@ret = ""
	def File.getAllFilesAsXML(dir)
		@ret << %Q(#{@spacer}<dir name="#{dir}">) << "\n"
		@spacer += "\t"
		getFiles(dir){|f|
			file = getPath(dir) + getFile(f)
			
			if(FileTest.directory?(file))
				getAllFilesAsXML(file)
			elsif(FileTest.file?(file))
				@ret << %Q(#{@spacer}<file name="#{File.basename(file)}"/>) << "\n"
			end
		}
		@spacer.sub!(/\t/, '')
		@ret << %Q(#{@spacer}</dir>) << "\n"
	end

	@spacer = ""
	@ret = ""
	def File.getAllFiles(dir)
		@ret << "#{@spacer}#{dir}" << "\n"
		@spacer += "\t"
		getFiles(dir){|f|
			file = getPath(dir) + getFile(f)
			
			if(FileTest.directory?(file))
				getAllFiles(file)
			elsif(FileTest.file?(file))
				@ret << "#{@spacer}#{File.basename(file)}" << "\n"
			end
		}
		@spacer.sub!(/\t/, '')
		@ret << "#{@spacer}"
	end

	def File.eachFileContent(dir)
		return unless(FileTest.exists?(dir))
		Dir.foreach(dir) do |file|
			unless(file == "." || file == "..")
				yield(getPath(dir), getFile(file), getContent(dir, file))
			end
		end
	end
	
	def File.write(dir, file, content)
		File.open(getPath(dir)+getFile(file), "w") do |f|
			f.print(content)
		end
	end
	
end