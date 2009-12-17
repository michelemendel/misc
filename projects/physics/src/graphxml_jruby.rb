#
# GraphXML parsing and other methods.
#
# see:: http://libxml.rubyforge.org/rdoc/
# see:: GraphXML http://staff.science.uva.nl/~marshall/publications/GraphXMLShort.pdf
# see:: RGL http://rgl.rubyforge.org/
# 

require 'pp'
require 'rubygems'
require 'hpricot'
require 'graph'

class GraphXMLParser
  def parse(file)
    doc = Hpricot.XML(open(file))

    nodes = []
    (doc/:node).each do |n|
      position = (n/:position).first
      nodes << Gnode.new(
        n[:name], position[:x].to_f, position[:y].to_f, n[:mass].to_f
      )
    end
    
    edges = []
    (doc/:edge).each do |e|
      is_directed = e[:isDirected].nil? ? false : e[:isDirected]=='true' ? true : false
      source = nodes.find {|n| n.name == e[:source] }
      target = nodes.find {|n| n.name == e[:target] }
      edges << Gedge.new(source, target, e[:k].to_f, e[:zfl].to_f, is_directed)
    end
    return nodes, edges
  end
end

#
if($0==__FILE__)
  parser = GraphXMLParser.new

  file = 'graphs/graph2.xml'
  nodes, edges = parser.parse(file)
  pp nodes;puts;pp edges

end
