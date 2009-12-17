#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Korundum'

about = KDE::AboutData.new("app2", "App2", "1.0")
KDE::CmdLineArgs.init(ARGV, about)
a = KDE::Application.new()

ref = KDE::DCOPRef.new("app1", "MyWidget")
res = ref.call("mySize()")

puts "W: #{res.width} H: #{res.height}"



