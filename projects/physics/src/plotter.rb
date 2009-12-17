#
# Plotter.
# 

require 'pp'
require 'scruffy'
require 'scruffy_line_mod'

# title: title of graph and file
# legend_titles: name for each line
# data: array of arrays
def plot(title, legend_titles, data)
  graph = Scruffy::Graph.new
  graph.title = title
  graph.renderer = Scruffy::Renderers::Standard.new
  data.each_index do |idx|
    graph.add(:line, legend_titles[idx], data[idx],
      {'stroke-width'=> 7, :stroke => 'black'})
  end
  graph.render :to => "#{title}.svg", :width=>500, :height=>400
end
