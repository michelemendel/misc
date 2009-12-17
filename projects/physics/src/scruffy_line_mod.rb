

module Scruffy::Layers
  class Line < Base
    def draw(svg, coords, options={})
      # The line
      svg.polyline(
        :points=>stringify_coords(coords).join(' '),
        :fill => 'none',
        :stroke => color.to_s,
        'stroke-width' => relative(0.7)
      )

      # The line markers
      coords.each do |coord|
        svg.circle(
          :cx=>coord.first,
          :cy=>coord.last,
          :r=>relative(0),
          :style=>"stroke-width:#{relative(0)}; stroke:#{color.to_s}; fill:#{color.to_s}"
        )
      end
    end
  end
end
