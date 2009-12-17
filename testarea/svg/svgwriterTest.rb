require 'svg_writer.rb'

doc = Svg_doc.new
r = doc.root
r.viewBox = '0 0 30 20'
(1..3).each do |integer|
  c = Circle.new
  c.r = integer
  c.cx = c.cy = integer*2
  r.push c
end

puts doc
