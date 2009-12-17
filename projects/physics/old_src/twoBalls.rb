require 'pp'
require 'gui'
require 'rk4-balls'

include PhysicsMain

class Spring < RK4
    
    def initialize
        super
        
        @ballA = State.new
        @ballB = State.new
        
        @ballA.name = "ball A"
        @ballA.x, @ballA.y = 250, 250
        @ballA.vx, @ballA.vy = 0, 0
        @ballA.animate = true
        @ballA.grabbed = false
        @ballA.other = @ballB
        
        @ballB.name = "ball B"
        @ballB.x, @ballB.y = 300, 251
        @ballB.vx, @ballB.vy = 0, 0
        @ballB.animate = true
        @ballB.grabbed = false
        @ballB.other = @ballA
        
        @zeroForceDist = 150
        @repulsionConst = 1e5
        @r = 10
    end
    
    def setMaxDimensions(maxWidth, maxHeight)
        @maxWidth, @maxHeight = maxWidth, maxHeight
    end
    
    #~ def moveToPoint(x, y)
        #~ @state.x = x
        #~ @state.y = y
    #~ end

    #~ def grab(x, y)
        #~ @state.animate = false
        #~ @state.grabbed = true
        #~ @state.x = x
        #~ @state.y = y
    #~ end

    #~ def release
        #~ @state.animate = true
        #~ @state.grabbed = false
    #~ end
    
    #~ def move(x, y)
        #~ if(@state.grabbed)
            #~ @state.x = x
            #~ @state.y = y
        #~ end
    #~ end


    def integrate(t, dt)
        super(@ballA, t, dt)
        super(@ballB, t, dt)
    end
    
    def acceleration(state, t)
        k = 0.1
        b = 0.1
        dx = state.x - state.other.x
        dy = state.y - state.other.y
        d = Math.sqrt(dx**2 + dy**2)
        
        springX = -k*(d-@zeroForceDist)*dx/d - b*state.vx
        springY = -k*(d-@zeroForceDist)*dy/d - b*state.vy
        repulsionX = dx==0 ? 0 : 1/(d*d)*dx/d * @repulsionConst
        repulsionY = dy==0 ? 0 : 1/(d*d)*dy/d * @repulsionConst
        
        accX = springX + repulsionX
        accY = springY + repulsionY
        
        return accX, accY
    end
    
    def render(sdc)
        sdc.foreground = FXColor::Blue
        sdc.fillCircle(@ballA.x, @ballA.y, @r)
        sdc.fillCircle(@ballB.x, @ballB.y, @r)
        sdc.drawLine(@ballA.x, @ballA.y, @ballB.x, @ballB.y)
    end
    
    def leftButtonPressed(x, y)
        #~ grab(x,y)
    end
    def leftButtonReleased(x, y)
        #~ release
    end
    def mouseMove(x, y)
        #~ move(x,y)
    end
    
end

model = Spring.new
runApp(model)
