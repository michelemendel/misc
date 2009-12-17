require 'monitor'

class WordList < Monitor
    #~ include MonitorMixin
    
    def initialize
        super()
        @nofPos = 7
        @ab = []
        @ab.concat(('a'..'z').to_a)
        @ab.concat(('0'..'9').to_a)
        
        @abSize = @ab.size
        @nofWords = @ab.length ** @nofPos
        puts "nofPos=#{@nofPos}, abSize=#{@abSize} -> nofWords=#{@nofWords}"

        @words = []
        @idx = []
        @isAdd = []
        @nofPos.times { |i|
            @words[i] = @ab
            @idx[i] = 0
            @isAdd[i] = false
        }
        @count = 0
    end
    

    def getNext(debug = false)
        synchronize do
            i = @count % @abSize
            
            idxStr = ""
            @idx[0] = i
            idxDebug = "#{@count}: "
            idxDebug += "#{@idx[0]} "
            (@nofPos-1).times { |j|
                add = 0
                if(@idx[j]==0 && @isAdd[j+1])
                   @isAdd[j+1] = false
                   add = 1
                end
                @idx[j+1] = (@idx[j+1] + add) % @abSize
                idxDebug += "#{@idx[j+1]} "
                
                @isAdd[j+1] = true if(@idx[j]==@abSize-1)
            }
            puts idxDebug if debug
            idxDebug += "\n"
            
            word = ""
            @nofPos.times { |j|
                word += @words[j][@idx[j]]
            }
    
            @count += 1
            return false if(@count==@nofWords+1)
            return word, @count
        end
    end

end

#~ wl = WordList.new
#~ loop do
    #~ w, count = wl.getNext(false)
    #~ break unless w
    #~ puts w
#~ end

