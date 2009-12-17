
def bin_to_string(str)
    a = str.split
    a.each { |w| print "#{w}".to_i(2).chr }
    puts
end

def string_to_bin(str)
    wrap = 6
    counter = 0
    str.chomp.each_byte { |b| 
        counter += 1
        # print("#{b.to_s(2)} ")
        printf("%s ", b.chr.unpack('B8'))
        puts if counter % wrap == 0        
    }
    puts
end


bin = <<-HERE 
01010111 01100101 01101100 01101100 00101100 00100000
01111001 01101111 01110101 00100111 01110010 01100101
00100000 01110111 01100101 01101001 01110010 01100100
HERE

bin = <<-HERE 
01100010 01100001 01101110 01100001 
01101110 01100001
HERE

bin_to_string(bin)

str = <<-HERE 
Klockan 13.00 eller 13.30 tror jag.
HERE

string_to_bin(str)


