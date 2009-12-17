#
# Orchestrate the whole thing.
# 

require 'rk4'
require 'force_function'
require 'graph'
require 'mri_or_jruby'

def start_app
  # Particles and springs

  parser = GraphXMLParser.new
  file = 'graphs/graph2.xml'
  nodes, edges = parser.parse(file)

  printf("%6s %9s %7s %7s %7s %7s %7s\n", "t", "x", "y", "vx", "vy", "fx", "fy")

  t = 0
  dt = 0.1
  end_time = 20
  rk4 = Rk4.new(ParticlesAndSprings.new)

  while(t<=end_time)
    nodes.each_index do |idx|
      printf("#{idx}: % 5.1f % 7.2f % 7.2f % 7.2f % 7.2f % 7.2f % 7.2f\n",
        t, nodes[idx].x, nodes[idx].y, nodes[idx].vx, nodes[idx].vy,
        nodes[idx].fx, nodes[idx].fy) #if(t%1<0.001)

    end
    t += dt
  end

end

start_app




