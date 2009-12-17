require 'getoptlong'

class GetoptLong
    alias old_init initialize

    def initialize(*options)
        @descriptions = Hash.new

        options.each do |arg|
            key = arg[0..1]
            desc = arg[3]
            @descriptions[key] = desc
            arg.pop
        end

        old_init(*options)
    end

    def usage(message="Usage:")
        puts "#{message}"

        @descriptions.sort.each do |k, v|
            printf "%-25s => %-40s\n", k.join(", "), v
        end
    end
end

