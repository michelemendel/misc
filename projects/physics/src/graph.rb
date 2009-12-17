#
# Graph related code.
#

require 'pp'

# This represents the phase space vector x (gafferongames).
class Gnode
  attr_accessor :name, :x, :y, :vx, :vy, :fx, :fy, :m
  attr_accessor :x_tmp, :y_tmp, :vx_tmp, :vy_tmp
  attr_accessor :edges, :animate, :grabbed

  def initialize(name, x, y, m=1)
    @name, @x, @y, @m = name, x, y, m
    @vx = @vy = @fx = @fy = 0
    @edges = []
    @grabbed = false
  end

  def add_edge(edge)
    @edges << edge
  end

  def delta_length(state, edge)
    on_x, on_y = edge.pos_other_node(self, @x, @y)

    dist_x = state.x - on_x
    dist_y = state.y - on_y

    dist = Math.sqrt(dist_x**2 + dist_y**2)

    uv_x = dist==0 ? 0 : dist_x / dist  #uv=unit vector
    uv_y = dist==0 ? 0 : dist_y / dist

    dx = (dist - edge.zfl) * uv_x
    dy = (dist - edge.zfl) * uv_y
    
    return dx, dy
  end

  def position
    return @x, @y
  end
end


# Will be represented as a spring.
# zfl = zero force length
class Gedge
  attr_accessor :name, :source, :target, :is_directed, :k, :zfl

  def initialize(source, target, k, zfl, is_directed=false, name='')
    @source, @target = source, target
    @zfl = zfl
    @name = name
    @is_directed = is_directed.nil? ? false : is_directed=='true' ? true : false
    @k = k
    @pos_lock_counter = 0

    source.add_edge(self)
    target.add_edge(self)
  end

  # Stores position to be used for the other node.
  def pos_other_node(node, x, y)
    @pos_lock_counter    = 0    if @pos_lock_counter == 8
    @x_locked, @y_locked = x, y if @pos_lock_counter == 0

    if(@pos_lock_counter < 4)
      ret_x, ret_y = other_node(node).position
    else
      ret_x, ret_y = @x_locked, @y_locked
    end

    #    printf("%s:%d: (%.2f %.2f) (%.2f %.2f)\n",
    #      node.name, @pos_lock_counter, node.x, ret_x, node.y, ret_y)

    @pos_lock_counter += 1
    return ret_x, ret_y
  end

  def length
    Math.sqrt((source.x-target.x)**2 + (source.y-target.y)**2)
  end

  def other_node(node)
    node == @source ? @target : @source
  end
end


if($0==__FILE__)

  

end