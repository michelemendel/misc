# The bumpspark method takes an Array and builds a sparkline graph from each of 
# the numbers stored contained in that object.  The method returns a string containing a bitmap.
#                                                                                                                 # See http://whytheluckystiff.net/bumpspark/ for details.
def bumpspark( results )
    white, red, grey = [0xFF,0xFF,0xFF], [0,0,0xFF], [0x99,0x99,0x99]
    ibmp = results.inject([]) do |ary, r|
        ary << [white]*15 << [white]*15
        ary.last[r/9,4] = [(r > 50 and red or grey)]*4
        ary
    end.transpose.map do |px|
        px.flatten!.pack("C#{px.length}x#{px.length%4}")
    end.join
    ["BM", ibmp.length + 54, 0, 0, 54, 40, results.length * 2, 15, 1, 24, 0, 0, 0, 0, 0, 0].pack("A2ISSIIiiSSIIiiII") + ibmp
end


ar = []
#~ bumpspark(ar)
#~ p bumpspark((0..22).map{ rand 100 })

File.open( 'sparkline.bmp', 'wb' ) do |bmp|
    bmp.print(bumpspark((0..200).map{ rand 100 }))
end


#~ header = [137, 80, 78, 71, 13, 10, 26, 10].pack("C*")
#~ p header