
# Runge Kutta order 4

class RK4
   
  def integrate(state, t, dt)
    if(state.animate)
      a = evaluate_cur_time(state, t) #Note: Returns derivative at current time 't'
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

  def evaluate_cur_time(initialState, t)
    output = Derivative.new
    output.dx = initialState.vx
    output.dy = initialState.vy
    output.dvx, output.dvy = acceleration(initialState, t)
    return output;
  end

  def evaluate(initialState, t, dt, derivative)
    state = State.new
    state.x = initialState.x + derivative.dx*dt
    state.y = initialState.y + derivative.dy*dt
    state.vx = initialState.vx + derivative.dvx*dt
    state.vy = initialState.vy + derivative.dvy*dt
        
    output = Derivative.new
    output.dx = state.vx
    output.dy = state.vy
    output.dvx, output.dvy = acceleration(state, t+dt)
    return output;
  end
    
  def acceleration(state, t)
    k = 5
    b = 0
    acc_x = -k * state.x - b*state.vx
    acc_y = -k * state.y - b*state.vy
    return acc_x, acc_y
  end
    
end

class State
  attr_accessor :x, :y, :vx, :vy #position, velocity
  attr_accessor :animate #if this object should be animated
  attr_accessor :grabbed #if this object is grabbed
end

class Derivative
  attr_accessor :dx, :dy, :dvx, :dvy
end


class Test < RK4
  def test
    state = State.new
    state.x = 100
    state.y = 100
    state.vx = 0
    state.vy = 0
    state.animate = true
    t = 0
    dt = 0.1
        
    while((state.x).abs>0.001 || (state.y).abs>0.001 || (state.vx).abs>0.001)
      printf("%.2f, %.2f, %.2f, %.2f\n", state.x, state.y, state.vx, state.vy)
      integrate(state, t, dt)
      t += dt
    end
  end
end

if(__FILE__==$0)
  Test.new().test
end