

def parse_a(file)
    fields_and_sizes = [[:track,30],
                        [:artist,30],
                        [:album, 30],
                        [:year,4],
                        [:comment,30],
                        [:genre,1]]
    open(file) do |f|
        f.seek(-128, IO::SEEK_END)
        if(f.read(3) == "TAG")
            fields_and_sizes.each do |field, size|
                data = f.read(size)
                data.gsub!(/\000.*/, "")
                data = data[0] if(field == :genre)
                puts "#{field}:#{data}"
                
            end
        end
    end
end

def parse_b(file)
    format = "Z30Z30Z30Z4Z30C"
    open(file) do |f|
        f.seek(-128, IO::SEEK_END)
        if(f.read(3) == "TAG")
            puts f.read(125).unpack(format)
        end
    end
end

f = "17-Her Majesty.mp3"
f = "f1.mp3"

parse_a(f)
puts
parse_b(f)

