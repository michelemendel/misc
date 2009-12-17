
require 'fileutils'

include FileUtils::Verbose

def get_info(file)
    open(file+".mp3") do |f|
        f.seek(-128, IO::SEEK_END)
        if(f.read(3) == "TAG")
            data = f.read(30)
            data.gsub!(/\000.*/, "")
            puts "##{data}#"                
        end
    end
end

#
def write_track(file, track_name)
    open(file+".mp3","rb+") do |f|
        f.seek(-128, IO::SEEK_END)
        if(f.read(3) == "TAG")
            f.write(track_name)
        end
    end
end

def copy(src, tgt)
 cp(src + ".mp3",  tgt + ".mp3", :verbose => false)    
end

orig = "orig"
@dest_dir = "bs/"
nof_files = 2000

start_time = Time.now
(1..nof_files).each do |i| 
    cp = "f#{i}"
    copy(orig, @dest_dir + cp)
    write_track(@dest_dir + cp, cp)
end
end_time = Time.now
puts "#{end_time - start_time} s"