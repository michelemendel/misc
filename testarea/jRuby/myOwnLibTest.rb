require "java"
require "mm.jar"
require "CosEJBClient.jar"
require "COSMOS.jar"
require "gnu-regexp.jar"
require "log4j.jar"
#~ require "weblogic.jar"


module J
	include_package "mm"
    #~ include_package "com.telenor.cos.system.core"
	#~ include_package "com.telenor.cosmos.exceptions"
end

h = J::Hello.new()
h.printHello()
puts

#~ --------------------------------------------

#~ init = ["CosClient","ast-wt01:7101","0"]
#~ J::ComponentSetup.init(init)

