
#==============================================================================#
# sample5.rb
# $Id: sample5.rb,v 1.6 2002/11/19 10:15:34 rcn Exp $
#==============================================================================#

#==============================================================================#

require 'svg/svg'

#==============================================================================#

svg = SVG.new('4in', '4in', '0 0 400 400')

svg << SVG::Circle.new(200, 130, 100) {
  self.style = SVG::Style.new(:fill => 'red', :fill_opacity => 0.5)
}

svg << SVG::Circle.new(200, 130, 100) {
  self.transform = 'rotate(120 200 200)'
  self.style     = SVG::Style.new(:fill => 'green', :fill_opacity => 0.5)
}

svg << SVG::Circle.new(200, 130, 100) {
  self.transform = 'rotate(240 200 200)'
  self.style     = SVG::Style.new(:fill => 'blue', :fill_opacity => 0.5)
}

print svg.to_s

samplefile = File.new("sample5.svg", 'w')
samplefile.write(svg.to_s)


#==============================================================================#
#==============================================================================#
