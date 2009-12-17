
# Runge Kutta order 4

class RK4

    def initialize
        @state = State.new
        @output = Derivative.new
    end
    
    def integrate(state, t, dt)
        if(state.animate)
        a = evaluateCurTime(state, t) #Note: Returns derivative at current time 't'
        b = evaluate(state, t, dt*0.5, a)
        c = evaluate(state, t, dt*0.5, b)
        d = evaluate(state, t, dt, c)
        
        dxdt = 1.0 / 6.0 * (a.dx + 2.0 * (b.dx + c.dx) + d.dx)
        dydt = 1.0 / 6.0 * (a.dy + 2.0 * (b.dy + c.dy) + d.dy)
        dvxdt = 1.0 / 6.0 * (a.dvx + 2.0 * (b.dvx + c.dvx) + d.dvx)
        dvydt = 1.0 / 6.0 * (a.dvy + 2.0 * (b.dvy + c.dvy) + d.dvy)
        
        state.x = state.x + dxdt * dt
        state.y = state.y + dydt * dt
        state.vx = state.vx + dvxdt * dt
        state.vy = state.vy + dvydt * dt
        end
    end

    def evaluate(initialState, t, dt, derivative)
        @state = initialState
        @state.x = initialState.x + derivative.dx*dt
        @state.y = initialState.y + derivative.dy*dt
        @state.vx = initialState.vx + derivative.dvx*dt
        @state.vy = initialState.vy + derivative.dvy*dt
        
        return evaluateCurTime(@state, t+dt)
    end

    def evaluateCurTime(state, t)
        @output.dx, @output.dy = state.vx, state.vy
        @output.dvx, @output.dvy = acceleration(state, t)
        
        return @output;    
    end
end

class State
    attr_accessor :x, :y, :vx, :vy #position, velocity
end

class Derivative
    attr_accessor :dx, :dy, :dvx, :dvy
end


class State
    attr_accessor :id, :name
    attr_accessor :animate #if this object should be animated or not
    attr_accessor :grabbed #if this object is grabbed
    attr_accessor :connectedNodes, nonConnectedNodes # the other state (ball)
end
