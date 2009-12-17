#
# Orchestrate the whole thing.
# 

require 'rk4'
require 'force_function'
require 'graph'
require 'mri_or_jruby'
require 'plotter'

def test_run
  # Particles and springs

  parser = GraphXMLParser.new
  file = 'graphs/graph2.xml'
  nodes, edges = parser.parse(file)
  #  nodes[1].grabbed = true

  #  pp nodes; #puts;
  #  edges.each do |e|
  #    pp e
  #    pp e.length
  #    pp e.delta_length
  #  end
  #  exit



  # Values for the plotter
  x_vals = []; vx_vals = []
  y_vals = []; vy_vals = []
  dx_vals = []; dy_vals = []
  nodes.each_index do |idx|
    x_vals[idx] = []; vx_vals[idx] = []
    y_vals[idx] = []; vy_vals[idx] = []
    dx_vals[idx] = []; dy_vals[idx] = []
  end

  #  printf("%6s %9s %7s %7s\n", "t", "x", "vx", "fx")
  printf("%6s %9s %7s %7s %7s %7s %7s\n", "t", "x", "y", "vx", "vy", "fx", "fy")

  t = 0
  dt = 0.1
  rk4 = Rk4.new(ParticlesAndSprings.new)
  while(t<=20)
    nodes.each_index do |idx|
      #      printf("#{idx}: % 5.2f % 7.2f % 7.2f % 7.2f\n",
      #        t, nodes[idx].x, nodes[idx].vx, nodes[idx].fx)
      printf("#{idx}: % 5.1f % 7.2f % 7.2f % 7.2f % 7.2f % 7.2f % 7.2f\n",
        t, nodes[idx].x, nodes[idx].y, nodes[idx].vx, nodes[idx].vy,
        nodes[idx].fx, nodes[idx].fy) #if(t%1<0.001)

      x_vals[idx] << nodes[idx].x
      vx_vals[idx] << nodes[idx].vx
      y_vals[idx] << nodes[idx].y
      vy_vals[idx] << nodes[idx].vy

      rk4.integrate(nodes[idx], t, dt)
    end
    t += dt
  end

  nodes.each_index do |idx|
    plot("#{idx}x, #{idx}y", ["#{idx}x", "#{idx}y"], [x_vals[idx], y_vals[idx]])
    plot("#{idx}vx, #{idx}vy", ["#{idx}vx", "#{idx}vy"], [vx_vals[idx], vy_vals[idx]])
  end
end

test_run




