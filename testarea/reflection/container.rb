require 'singleton'

# Components to use
require 'comp1'
require 'comp2'

class Module
	def component(id,klass)
		module_eval <<-"end_eval"
			def init
				puts "init: id=#{id}, class=#{klass}"
				@#{id.id2name} = #{klass}.new
			end
			#~ self.init
		end_eval
	end
end

class MMContainer
	include Singleton

	def initialize
		@ch = Hash.new
	end

	def add(c)
		#~ @ch[]
		@#{id.id2name} = #{klass}.new
	end

	def get

	end

	def start

	end
end

#~ mc = MMContainer.instance
#~ mc.add(Comp1)
#~ mc.add(Comp2)
#~ mc.start
