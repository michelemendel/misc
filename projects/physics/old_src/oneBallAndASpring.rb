require 'gui'
require 'rk4-singleBall'

include PhysicsMain

class Spring < RK4
    
    def initialize
        @state = State.new
        @state.x = 150
        @state.y = 250
        @state.vx = 0
        @state.vy = 0
        @state.animate = true
        @state.grabbed = false
        @r = 10
        
        @zeroForceDist = 100
        
        @fixedX = 300
        @fixedY = 200
        
        @curX = 0
        @curY = 0
    end
    
    def setMaxDimensions(maxWidth, maxHeight)
        @maxWidth, @maxHeight = maxWidth, maxHeight
    end
    
    def moveToPoint(x, y)
        @state.x = x
        @state.y = y
    end

    def grab(x, y)
        @state.animate = false
        @state.grabbed = true
        @state.x = x
        @state.y = y
        @state.vx, @state.vy = 0, 0
    end

    def release
        @state.animate = true
        @state.grabbed = false
    end
    
    
    def move(x, y)
        if(@state.grabbed)
            @state.x = x
            @state.y = y
            @state.vx = (x-@curX)*100
            @state.vy = (y-@curY)*100
            @curX = x
            @curY = y
        end
    end


    def integrate(t, dt)
        super(@state, t, dt)
    end
    
    def acceleration(state, t)
         k = 5
         b = 0.00001
         
         dx = state.x - @fixedX
         dy = state.y - @fixedY
         d = Math.sqrt(dx**2 + dy**2)
         
         accX = -k*(d-@zeroForceDist)*dx/d - b*state.vx
         accY = -k*(d-@zeroForceDist)*dy/d - b*state.vy
         return accX, accY
    end
    
    def render(sdc)
        sdc.foreground = FXColor::Blue
        sdc.fillCircle(@state.x, @state.y, @r)
        sdc.drawLine(@fixedX, @fixedY, @state.x, @state.y)
    end
    
    def leftButtonPressed(x, y)
        grab(x,y)
    end
    def leftButtonReleased(x, y)
        release
    end
    def mouseMove(x, y)
        move(x,y)
    end
    
end

model = Spring.new
runApp(model)
