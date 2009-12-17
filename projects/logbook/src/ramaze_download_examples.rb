# Downloads all examples from 
# http://darcs.ramaze.net/ramaze/examples/

require 'open-uri'
require 'pp'

#
def download(url, fn)
    begin
        open(url) do |src|
            open(fn, 'w') { |f| f.write(src.read) }
        end
    rescue OpenURI::HTTPError
        puts "--x-> Can't download #{url}"
    end
end

class String
    def dir?
        self.match(/\//) ? true : false
    end
end

LINK_RE = /^<a href="([\w\.\/]+)">/im

#
def crawl(url, dir_dest)
    Dir.mkdir(dir_dest) unless File.exists?(dir_dest)
    Dir.chdir(dir_dest)
    open(url) do |src|
        page = src.read
        page.scan(LINK_RE) do |link|
            link = link[0]
            if(link.dir?)
                crawl(url + link, link.tr!('/',''))
            else
                puts "--d-> download #{url+link} to #{dir_dest}"
                download(url+link, link)
            end
        end
        Dir.chdir('..')
    end
end

url_root = 'http://darcs.ramaze.net/ramaze/examples/'
dir_dest = 'ramaze_examples'
crawl(url_root, dir_dest)

