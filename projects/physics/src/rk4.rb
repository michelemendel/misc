#
# Implementing Runge-Kutta 4.
#
# 2 dimensions
#
# see: http://gafferongames.wordpress.com/game-physics/integration-basics/
# 

require 'pp'

class Rk4
  State = Struct.new(:x, :y, :vx, :vy)
  Derivative = Struct.new(:dx, :dy, :dvx, :dvy)

  def initialize(force_function)
    @force_function = force_function
  end

  def integrate(state, t, dt)
    a = evaluate(state, t, 0.0, Derivative.new(0,0,0,0))
    b = evaluate(state, t, dt*0.5, a)
    c = evaluate(state, t, dt*0.5, b)
    d = evaluate(state, t, dt, c)

    state.x  += 1.0/6.0 * dt * (a.dx + 2.0*(b.dx + c.dx) + d.dx)
    state.y  += 1.0/6.0 * dt * (a.dy + 2.0*(b.dy + c.dy) + d.dy)
    state.vx += 1.0/6.0 * dt * (a.dvx + 2.0*(b.dvx + c.dvx) + d.dvx)
    state.vy += 1.0/6.0 * dt * (a.dvy + 2.0*(b.dvy + c.dvy) + d.dvy)
  end

  # returns Derivative
  def evaluate(state, t, dt, deriv)
    state_tmp = State.new(0,0,0,0)
    state_tmp.x = state.x + deriv.dx*dt
    state_tmp.y = state.y + deriv.dy*dt
    state_tmp.vx = state.vx + deriv.dvx*dt
    state_tmp.vy = state.vy + deriv.dvy*dt

    output = Derivative.new(0,0,0,0)
    output.dx = state_tmp.vx
    output.dy = state_tmp.vy
    state.fx, state.fy = @force_function.calculate_force(state_tmp, state, t+dt)
    output.dvx, output.dvy = state.fx/state.m, state.fy/state.m
    return output
  end
end
























