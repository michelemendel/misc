require "pp"
require "singleton"

#~ module Containerable
	#~ def method_added(id)
		#~ print "Adding ", id.id2name, "\n"
	#~ end

	#~ def append_features(c)
		#~ p "appendFeatures"
		#~ c.each{|cd| puts cd}
	#~ end
#~ end


class Class
	#~ alias oldNew new

	#~ def new(*args)
		#~ p args.length
		#~ args.each{|a| p a}
		#~ self.send(:init)
		#~ puts id.id2name
		#~ oldNew(*args)
	#~ end
end



class Class
	class << self
		def components(*ids)
		end
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
		#~ puts %Q/adding #{className} to container/ # "#{@containerName}"/
	end

	def get(k)
		if @comps.has_key?(k)
			return @comps[k]
		elsif
			puts "#{k} doesn't exists"
		end

	end

	def start
		#~ puts "Starting container"
	end
end


class Comp1
	def addOne(nr)
		nr += 1
	end
end

class Comp2
	def say(str)
		puts str
	end
end

#~ def Comp2.components (*ids)
  #~ for id in ids
    #~ module_eval <<-"end_eval"
      #~ alias_method :__#{id.to_i}__, #{id.inspect}
      #~ def #{id.id2name}(*args, &block)
        #~ def self.#{id.id2name}(*args, &block)
          #~ @__#{id.to_i}__
        #~ end
        #~ @__#{id.to_i}__ = __#{id.to_i}__(*args, &block)
      #~ end
    #~ end_eval
  #~ end
#~ end

class Comp3
	def Comp3.components (*args)
		hash = Hash[*args]
		hash.each { |var, comp|
			inst =  "@#{var}=#{comp}.new"
			puts inst
			module_eval(inst)
			puts @c1.addOne(3)
			#~ puts "#{var}=#{@var.class}"
			#~ puts var.to_i
			#~ puts @var.id2name
			#~ puts @var.id
			#~ @var.inspect

		}
	end

	components(:c1, Comp1) #, :c2, Comp2)

	def initialize(*a)
	end

	def doSomething
		"something"
	end

	def test(nr)
		@c1.addOne(nr)
	end

end



mc = Container.instance

mc.add(Comp1)
mc.add(Comp2)
mc.add(Comp3)

mc.start


c = mc.get("Comp3")
p c.test(3)




