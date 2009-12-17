#
# The function that calculates the acceleration.
#

require 'pp'

class ParticlesAndSprings
  # t is no always used.
  def calculate_force(state, node, t)
    b = 1
    tot_force_x = 0
    tot_force_y = 0

    # Spring and damping forces
    node.edges.each do |e|
      dx,dy = node.delta_length(state, e)

#      printf("%s: % 9.2f  % 9.2f % 9.2f\n", node.name, node.x, state.x, dx)

      tot_force_x += -e.k * dx - b * state.vx
      tot_force_y += -e.k * dy - b * state.vy

#      printf("%s: % 9.2f (%9.2f, %9.2f) % 9.2f\n",
#        node.name, node.x, dx, state.vx, tot_force_x)
#      printf("%s: % 9.2f % 9.2f % 9.2f % 9.2f % 9.2f % 9.2f\n",
#        node.name, node.x, node.y, dx, dy, tot_force_x, tot_force_y)
    end

    # Gravity and drag forces
#    tot_force_x -= 0.2*state.vx*state.vx
#    tot_force_y -= 9.8 - 0.2*state.vy*state.vy

    return tot_force_x, tot_force_y
  end
end
