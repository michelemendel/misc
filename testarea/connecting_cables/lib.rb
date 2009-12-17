require 'pp'

class Array
    def swap(idx)
        a = self.dup
        a[idx[0]-1], a[idx[1]-1] = a[idx[1]-1], a[idx[0]-1]
        a
    end  
end

def fly(test = false)
    # a = [1,2,3,4]
    a = %w{a b c d}
    all = []
    
    until all.size == 24
        all << a
        y = yield(all.size)
        if(!test)
            print "#{all.size}: #{y[0]}#{y[1]}: #{a}\n"
            a = a.swap(y)
            if(exists = all.index(a))
                puts "#{a} exists at #{exists + 1}"
                all << a
                return all
            end 
        end
    end
    all
end

