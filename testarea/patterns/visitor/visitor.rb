
class Shape
end

class Rectangle < Shape
    attr_accessor :x, :y, :width, :height
    
    def initialize( x, y, width, height )
        @x = x; @y = y; @width = width; @height = height
    end
    
    def union( rect )
        #~ ... # returns the union of two rectangles
    end
    
    def accept( visitor )
        visitor.visit_rectangle( self )
    end
end

class Line < Shape
    attr_accessor :x1, :y1, :x2, :y2
    
    def initialize( x1, y1, x2, y2 )
        @x1 = x1; @y1 = y1; @x2 = x2; @y2 = y2
    end
    
    def accept( visitor )
        visitor.visit_line( self )
    end
end

class Group < Shape
    #~ add( shape ) ...    # adds a shape to the group
    #~ remove( shape ) ... # removes a shape from the group
    #~ each ...            # iterates over shapes in the group
    
    def accept( visitor )
        visitor.visit_group( self )
    end
end

class X
    def initialize()    
    end
    
    def visit_line(shape)
        p caller
        p shape.class
    end
end

line = Line.new(1,2,3,4)
x = X.new()
line.accept(x)


