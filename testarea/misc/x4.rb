
class String
    def each_char(&block)
        split(//).each(&block)
    end
     
    def each_chr(pre)
        each_byte do |b|
            puts "#{pre}"
            puts "#{yield b.chr}"
        end
    end 
end 

s = "Hello Universe"

s.each_char {|c| puts c}
s.each_chr('CHAR IS') {|c| print c}


