RBWRAP_VERSION = "0.1.0"

# Return the Ruby modules (scripts or extensions) that are loaded when running
# the script 'mod'.
def analyze_dependencies_dynamically(mod)
  # Get names of modules loaded when running a script.
  # NOTE: This may not catch modules that are conditionally loaded.
  old_mods_loaded = $".clone
  puts "--------RUNNING ANALYZED SCRIPT:--------"
  eval "require '#{mod}'"
  puts "---END OF OUTPUT FROM ANALYZED SCRIPT---"
  depfiles = $" - old_mods_loaded

  # Find absolute paths to files
  deps = []
  depfiles.each do |depfile|
    catch(:next_file) do
      $:.each do |dir|
	if test(?f, dir + "/" + depfile)
	  deps.push [depfile, dir]
	  throw :next_file
	end
      end
      raise "Couldn't find file #{depfile}" # No file found
    end
  end

  return deps
end

# Dump a Numeric as data that can be read into an "int" in C.
def dump_as_c_int(i)
  [i].pack('l')
end

def dump_aligned_string(str)
  str + "\000" * ((str.length%4) ? (4-str.length%4) : 0)
end

# Dump string to a specified length. Pad with zeroes if shorter.
def dump_str_with_len_and_zero_pad(str, len)
  if str.length > len
    str[0...len]
  else
    str + "\000" * (len - str.length)
  end
end

class FileInfo
  @@dumped_int_size = dump_as_c_int(1).length
  def initialize(pos, len, name, unpack_dir = 0)
    @pos, @len, @name, @unpack_dir = pos, len, name, unpack_dir
  end
  def to_s
    str = dump_as_c_int(@pos) + dump_as_c_int(@len) + 
      dump_as_c_int(@unpack_dir) + dump_aligned_string(@name)
    dump_as_c_int(@@dumped_int_size + str.length) + str
  end
end

class WrapInfo
  def initialize(command_line, substitution_matchstr = "#unpack_dir#")
    @command_line, @substitution_matchstr = command_line, substitution_matchstr
  end
  def to_s
    dump_str_with_len_and_zero_pad(@substitution_matchstr, 16) + 
      dump_aligned_string(@command_line)
  end
end

class Cookie
  def initialize(count, len, fileinfo_pos, fileinfo_len, 
		 wrapinfo_pos, wrapinfo_len)
    @len, @fileinfo_pos, @fileinfo_len = len, fileinfo_pos, fileinfo_len
    @count, @wrapinfo_pos, @wrapinfo_len = count, wrapinfo_pos, wrapinfo_len
  end
  def to_s
    dump_as_c_int(@count) +
      dump_as_c_int(@len) + dump_as_c_int(@fileinfo_pos) + 
      dump_as_c_int(@fileinfo_len) + dump_as_c_int(@wrapinfo_pos) +
      dump_as_c_int(@wrapinfo_len) + "Feldt rbwrap 0.1.0\000\000"
  end
end

class FileWrap
  attr_accessor :command_line
  def initialize(command_line = nil)
    @data, @fileinfos, @command_line = "", [], command_line
  end
  def add_file(filename, filedata, current_dir = false)
    unpack_dir = (current_dir ? 1 : 0)
    @fileinfos.push FileInfo.new(@data.length, filedata.length, filename, 
				 unpack_dir)    
    @data += filedata
  end
  def to_s
    raise "No commandline specified" unless @command_line
    wrap = @data
    first_fi_pos = wrap.length
    toc = @fileinfos.each{|fi| fi.to_s}.join
    wrap += toc
    wi = WrapInfo.new(@command_line).to_s
    wrap += wi
    cookie = Cookie.new(@fileinfos.length, 
			wrap.length, @data.length, toc.length, 
			@data.length + toc.length, wi.length)
    wrap + cookie.to_s
  end
end

def exe_creator_uw_compile_wtdall(filewrap)
  # Get wrapped data as string
  wrap_str = filewrap.to_s

  # Match string that is unique enough that we can match it in the object file
  # produced.
  matchstr = "This is the string to match! It's pretty unique to rbwrap written by Robert Feldt, don't you think?"

  # Compile an object file with an empty char array of the same size as
  # the wrapped data.
  tfilename = "rbwrap_" + rand(10000).to_s
  File.open(tfilename + ".c", "w") do |cf|
    cf.write "int wd_len = #{wrap_str.length};\n" + 
    "char wd[#{wrap_str.length}] = \"#{matchstr}\";\n" +
    "char * wrapdata_buffer() {return &(wd[0]);}\n"
  end
  system("gcc -mno-cygwin -c #{tfilename}.c -o #{tfilename}.o")
  
  # Inject wrapped data into object file
  wdo = ""
  File.open(tfilename + ".o", "r") {|f| wdo = f.read}
  wdo[wdo.index(matchstr), wrap_str.length] = wrap_str
  File.open(tfilename + ".o", "w") {|f| f.write wdo}

  # Compile memunwrapper.c and link with wrapped data object file
  begin
    File.open("#{tfilename}2.c", "w") {|f| f.write MEMUNWRAPPER_C}
    system("gcc -mno-cygwin -c #{tfilename}2.c -o #{tfilename}2.o")
  rescue NameError
    system("gcc -mno-cygwin -c memunwrapper.c -o #{tfilename}2.o")
  ensure
    File.delete("#{tfilename}2.c")
  end
  system("gcc -mno-cygwin -o #{tfilename}.exe #{tfilename}2.o #{tfilename}.o")

  # Strip to reduce size. 
  system("strip #{tfilename}.exe")

  # Get exe as string
  ef = ""
  File.open(tfilename + ".exe", "r") {|f| ef = f.read}

  # Clean up files and return
  File.delete "#{tfilename}.c"
  File.delete "#{tfilename}.o"
  File.delete "#{tfilename}2.o"
  File.delete "#{tfilename}.exe"
  ef
end

# Append wrap to the end of unwrapper.exe. Assumes that unwrapper.exe is 
# available in the current dir.
def exe_creator_uw_append_wtdall(filewrap)
  ef = ""
  File.open("unwrapper.exe", "rb") {|uf| ef << uf.read}
  ef << filewrap.to_s
  ef
end

def find_file(filename, searchdirs)
  searchdirs.each do |dir|
    fullfilepath = dir + "/" + filename
    return fullfilepath if test(?f, fullfilepath)
  end
  nil
end

def find_ruby_binaries
  pathdirs = ENV['PATH'].split(":")
  pathdirs = ENV['PATH'].split(";") if (pathdirs[0] == ENV['PATH'])
    
  rf = find_file("ruby.exe", pathdirs)
  rf = find_file("ruby", pathdirs) unless rf
  raise "Couldn't find a Ruby binary named ruby.exe or ruby" unless rf

  # Following is a dirty hack! Is there some machine-independent way to find
  # the dependencies of a binary?
  # We read the ruby binary in and check what dll's it imports. We do this
  # by finding all matches to /\a\.dll/ in the binary. Then we strip away
  # Kernel32.dll and User32.dll since all Windows machines have them.
  dlls = []
  File.open(rf, "r") {|f| f.read.gsub(/[a-z,A-Z]*[a-z,0-9,A-Z,\-]+\.dll/) {|m| dlls.push m}}
  dlls.delete_if {|dll| ["kernel32.dll", "user32.dll"].include?(dll.downcase)}

  # Don't include cygwin1.dll if no-cygwin option given
  dlls.delete_if {|dll| dll.downcase == "cygwin1.dll"} if $options["nocygwin"]

  files = [rf]
  dlls.each {|dll| files.push find_file(dll, pathdirs)}
  files
end

if __FILE__ == $0
  if ARGV.length < 1
    puts "Usage: #{$0} [options] script.rb [files_to_include]*"
    puts ""
    puts "Options:"
    puts "--quiet, -q                Be quiet"
    puts "--no-upx                   Do not pack final exe with upx"
    puts "--no-cygwin                Do not include cygwin1.dll"
    puts "--no-ruby                  Do not include any ruby binaries"
    puts "--current-dir-unwrap       Wrapped exe will unpack were it is invoked"
    puts "--strip-ruby               Strip ruby.exe before wrapping it"
    exit -1
  end

  # Parse options
  require 'getoptlong'  
  $options = {}
  GetoptLong.new(
    ["--quiet", "-q", GetoptLong::NO_ARGUMENT],
    ["--no-upx", GetoptLong::NO_ARGUMENT],
    ["--no-cygwin", GetoptLong::NO_ARGUMENT],
    ["--no-ruby", GetoptLong::NO_ARGUMENT],
    ["--current-dir-unwrap", GetoptLong::NO_ARGUMENT],
    ["--strip-ruby", GetoptLong::NO_ARGUMENT],
    ["--command-line", GetoptLong::REQUIRED_ARGUMENT]
  ).each do |option, arg|
    $options[option.gsub("-","")] = arg
  end

  # Parse arguments
  main_program = ARGV[0]
  if $options["command-line"]
    cmd_line = $options["command-line"]
  else
    cmd_line = "#unpack_dir#ruby -I#unpack_dir# #unpack_dir#" + main_program
  end
  explicitly_specified_files = ARGV[1..-1]
  $bq = $options["quiet"]

  puts "Ruby Wrapper 'rbwrap' version #{RBWRAP_VERSION}" unless $bq
  puts "Copyright (c) Robert Feldt, feldt@ce.chalmers.se" unless $bq
  puts "" unless $bq

  # Create wrap with given command line
  puts "  Creating wrap with command line:\n    #{cmd_line}" unless $bq
  wrap = FileWrap.new(cmd_line)

  # Second arg is the main script. Get its dependencies and add the files.
  puts "  Analyzing dependencies of main script #{main_program}" unless $bq
  deps = analyze_dependencies_dynamically(main_program)
  print "  Adding dependency files\n    " unless $bq
  deps.each do |file, dir|
    File.open(dir + "/" + file, "rb") do |f| 
      print "#{file}, " unless $bq
      wrap.add_file(file, f.read, $options["current-dir-unwrap"])
    end
  end
  print"\n" unless $bq

  # Get the ruby binary and its dependencies
  if !$options["noruby"]
    puts "  Finding Ruby binary and its dependencies" unless $bq
    ruby_binfiles = find_ruby_binaries
    if ruby_binfiles
      print "  Adding ruby binary files\n    " unless $bq
      ruby_binfiles.each do |fn|
	filename = File.basename(fn)
	if ("ruby.exe" == filename) and $options["stripruby"]
	  # Strip before adding ruby.exe
	  File.open(fn,"r") do |refile|
	    tfn = "rbwrap_temp_#{rand(10000)}.exe"
	    File.open(tfn, "w") {|of| of.write refile.read}
	    system("strip " + tfn)
	    File.open(tfn, "r") do |f| 
	      print "#{filename}, " unless $bq
	      wrap.add_file(filename, f.read, $options["current-dir-unwrap"])
	    end
	    File.delete(tfn)
	  end
	else
	  File.open(fn, "rb") do |f|
	    print "#{filename}, " unless $bq
	    wrap.add_file(filename, f.read, $options["current-dir-unwrap"])
	  end
	end
      end
    print"\n" unless $bq
    end
  end

  # Add rest of the files specified on cmdline
  if explicitly_specified_files.length > 0
    print "  Adding explicitly specified files\n    " unless $bq
    explicitly_specified_files.each do |fn|
      File.open(fn, "rb") do |f|
	print "#{fn}, " unless $bq
	wrap.add_file(fn, f.read, $options["current-dir-unwrap"])
      end
    end
    print"\n" unless $bq
  end

  # Create executable
  puts "  Creating executable" unless $bq
  wrapexe = exe_creator_uw_compile_wtdall(wrap)

  # Pack with upx unless required not to
  if !$options["noupx"] 
    puts "  Packing file with UPX to reduce size and load times" unless $bq
    temp_filename = "rbwrap_temp_#{rand(10000)}.exe"
    File.open(temp_filename, "w") {|f| f.write wrapexe}
    if $bq
      system("upx -q -9 #{temp_filename}")
    else
      system("upx -9 #{temp_filename}")
    end
    File.open(temp_filename, "r") {|f| wrapexe = f.read}
    File.delete temp_filename
  end

  # Write exe to disc
  exefilename = File.basename(main_program, ".rb") + ".exe"
  File.open(exefilename, "w") {|wf| wf.write wrapexe }

  puts "  Created executable #{exefilename}"
end
