require 'container'


class Example
	component(:c1,Comp1)
	#~ component(:c2,Comp2)

	def go
		@c1.say("hello from class #{self.class}" )
		#~ @c2.say("hello from class #{self.class}" )
	end
end


#~ mc = MMContainer.instance
#~ mc.add(Example)
#eller
#mc.add(Example.new)
#eller
#mc.add(e)

e = Example.new
#~ e.init
#~ e.go
