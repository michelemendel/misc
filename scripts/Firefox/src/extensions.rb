#
# Listing Firefox extensions.
# 

require 'pp'
require 'find'

dir = 'C:\\Documents and Settings\\t538714\\Application Data\\Mozilla\\Firefox\\Profiles\\dpqk6ut7.default\\extensions'

Dir.chdir(dir)

exts = Dir.glob("*/install.rdf").collect do |f|
#  pp f
#  pp File.basename(f)
  m = IO.read(f).match(/<em:name>(.+)<\/em:name>/)
  m[1] if m
end.compact

pp exts.sort