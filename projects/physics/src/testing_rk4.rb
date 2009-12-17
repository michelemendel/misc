# Simple RK4 integration framework
# Copyright (c) 2004, Glenn Fiedler
# http://www.gaffer.org/articles

require 'pp'

class State
	attr_accessor :x, :v
end

class Derivative
  attr_accessor :dx, :dv
end

def integrate(state, t, dt)
	a = evaluate_init(state, t)
	b = evaluate(state, t, dt*0.5, a)
	c = evaluate(state, t, dt*0.5, b)
	d = evaluate(state, t, dt, c)

	state.x += dt * 1.0/6.0 * (a.dx + 2.0*(b.dx + c.dx) + d.dx)
	state.v += dt * 1.0/6.0 * (a.dv + 2.0*(b.dv + c.dv) + d.dv)

  puts "-"*33
end

def evaluate_init(initial, t)
  printf("evaluate: %.2f, %.2f\n", initial.x, initial.v)
	output = Derivative.new
	output.dx = initial.v
	output.dv = acceleration(initial, t)
	return output
end

def evaluate(initial, t, dt, d)
  printf("evaluate: %.2f, %.2f\n", initial.x, initial.v)
	state = State.new
	state.x = initial.x + d.dx*dt
	state.v = initial.v + d.dv*dt
	output = Derivative.new
	output.dx = state.v
	output.dv = acceleration(state, t+dt)
	return output
end

def acceleration(state, t)
	k = 10
	b = 1
  printf("acc: %.2f, %.2f\n", state.x, state.v)
	return - k*state.x - b*state.v
end


def main
	state = State.new
	state.x = 100
	state.v = 0

	t = 0
	dt = 0.1

  eps = 0.5
	while((state.x).abs>eps || (state.v).abs>eps)
#		printf("%.2f, %.2f\n", state.x, state.v)
		integrate(state, t, dt)
		t += dt
	end
end


main