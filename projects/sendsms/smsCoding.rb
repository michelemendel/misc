

def p(ar)
    ar.each { |c|
        printf("%d : 0x%X : %c\n", c, c, c)
    }
end


puts "ASCII Control characters"
p((0x00..0x1F).to_a << 0x7F)

puts "ASCII"
p((0x20..0x7E).to_a)

puts "Non-ASCII characters"
p((0x80..0xFF).to_a)

