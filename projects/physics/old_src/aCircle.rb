require 'gui'

include PhysicsMain

class Acircle
    
    RIGHT_X = 1
    LEFT_X = -1
    
    def initialize(startX, startY, radius, step)
        @x, @y, @r = startX, startY, radius
        @step = step
        @direction = RIGHT_X
    end
    
    def setMaxDimensions(maxWidth, maxHeight)
        @maxWidth, @maxHeight = maxWidth, maxHeight
    end
    
    def moveToPoint(x, y)
        @x = x
        @y = y
    end



    def integrate()
        @x += @step*@direction
        if(@x+@r > @maxWidth)
            @direction = LEFT_X
        elsif(@x-@r < 0)
            @direction = RIGHT_X
        end
    end
    
    def render(sdc)
        sdc.foreground = FXColor::Blue
        sdc.drawCircle(@x, @y, @r)
    end
    
    def leftButtonPressed(x, y)
        moveToPoint(x,y)
    end
    
end

model = Acircle.new(30, 50, 30, 5)
runApp(model)
