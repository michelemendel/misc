require "pp"
require "singleton"

class Class
	alias oldNew new

	def new(*args)
		#~ p args.length
		#~ args.each{|a| p a}
		#~ self.send(:init)
		#~ puts id.id2name
		oldNew(*args)
	end
end

class Container
	include Singleton

	def initialize(*args)
		#~ @h = @h || Hash.new
		@containerName = args[0]
		@comps = Hash.new
	end

	def add(c)
		className = c.name
		newClass = c.new
		@comps[c.name] = newClass
		puts %Q/adding #{className} to container/ # "#{@containerName}"/
	end
end

module Containerable
	def addMe
		mc = Container.instance
		#~ mc.add(self)
		puts self.class
	end

	def Containerable.test
		puts "test"
	end

	#~ def method_added(id)
		#~ print "Adding ", id.id2name, "\n"
	#~ end

	#~ def append_features(c)
		#~ p "appendFeatures"
		#~ c.each{|cd| puts cd}
	#~ end
end

class Comp1
	def addOne(nr)
		nr += 1
	end
end

class T1
	include Containerable

	def initialize(*a)
		@c = Comp1.new
	end

	def init
		puts "sss"
	end

	def test(nr)
		@c.addOne(nr)
	end

	s = new
	#~ addMe
end

#~ mc = Container.new("mycontainer")
#~ mc.add(T1)

#~ t = T1.new
#~ t.addMe

#~ ("hello", 2,3)
#~ puts t.test(3)








