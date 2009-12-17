require 'pp'


colmap = Array.new(25, "\000"*3)  # color map

# initialize colormap
(1..25).each {|i| 
    colmap[i] = [10+i*10, 0, rand*100].pack("CCC") 
}

puts colmap