require 'yaml'


graph = YAML.load(File.open("graph.yml"))

puts graph["node1"]["id"]
puts graph["node2"]["id"]

