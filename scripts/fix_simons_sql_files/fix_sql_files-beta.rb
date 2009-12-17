
#
# Script to add a new line to sql files
#
# author: Michele Mendel
# Oslo, 2006-06-20
#


usage = <<HERE
#{File.basename(__FILE__, '.rb')} -R[root] -C

-R  Start directory to run program. Leave blank to use current dir (only -R).
-C  Modify files. Without this, files are only checked.
HERE

if(ARGV.size==0)
	puts usage
	exit
end

ARGV.each do |arg|
	@root = arg.sub(/-R/,'') if(arg.match(/-R/))
	if(!@root || @root=='')
		@root = File.expand_path(".")
	end	
	
	@DRY_RUN = arg.match(/-C/) ? false : true
end

puts "Using dir (#{@root})"

# -------------------------------------------------------------------------------------------------

class String
	def ends_with?(str)
		self =~ /#{str}$/
	end
end

#
def fix_file(f)
	if(!File.file?(f) || !FileTest.exists?(f))
		puts "Dir '#{f}' doesn't exists"
		return
	end
	
	file = IO.readlines(f)
	lastline = file[-1]

	if(lastline =~ /^.*\s$/)
		msg = "nothing done"
	else
		msg = "added newline to"
		msg = "the following file will be changed" if @DRY_RUN
		puts "#{msg}:\n '#{f}'"
		File.new(f, "a") << "\n" unless @DRY_RUN
	end
end

#
def fix_files(file)
	path = file if(File.directory?(file))
	path += "/" unless path.ends_with?("/")
	Dir.foreach(file) do |f| 
		unless(f=="." || f== "..")
			f = path + f
			fix_files(f) if(File.directory?(f))
			fix_file(f) if(f.ends_with?("\\.sql"))
		end
	end
end

# Run script
fix_files(@root)

