require 'pp'

def q1
    imgWidth = 10
    imgHeight = 5
    
    (0...imgWidth).each { |x|
        (0...imgHeight).each { |y|
            z = (y * 512) + x
            printf("%d:%d\t%d\n", x, y, z)
        }
    }
end

def q2
    start = 5
    start.downto(0){|idx|
        print "#{idx} "
    }
    puts
end

q2