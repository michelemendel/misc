require 'zlib'
require 'fileutils'

include FileUtils::Verbose
include Zlib

testfile = "error.log.1.050911.gz"
@logdir = "logs"


def un_gzip(gz_fname, do_report=false)
    un_gz_fname = @logdir + "/" + gz_fname.sub('gz', 'log')

    File.open(un_gz_fname,'w') do |un_gz_f|
        GzipReader.open(gz_fname) {|gz_f|
            un_gz_f.write(gz_f.read)
        }
    end
    
    #Report
    if(do_report)
        dir = File.expand_path(File.dirname(un_gz_fname))
        printf("%s unzipped to %s in dir %s\n", gz_fname, un_gz_fname, dir)
    end
end

def init_logdir
    if(File.directory?(@logdir))
        Dir.chdir(@logdir)
        Dir.glob("*") { |fn|
            puts fn
            File.delete(fn)
        }
        Dir.chdir("..")
        Dir.rmdir(@logdir) 
    end
    Dir.mkdir(@logdir)
end 

#~ init_logdir

un_gzip(testfile, true)

