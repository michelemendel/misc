class Module
	@@docs = Hash.new(nil)
	def doc(str)
		puts "running Module.doc from #{self.name}"
		@@docs[self.name] = str
	end

	def Module::doc(aClass)
		# If we're passed a class or module, convert to string
		# ('<=' for classes checks for same class or subtype)
		aClass = aClass.name if aClass.class <= Module
		@@docs[aClass] || "No documentation for #{aClass}"
	end

	def atr(id)
		module_eval <<-"end_eval"
			def #{id.id2name}=(v)
				@#{id.id2name} = v
			end

			def #{id.id2name}
				@#{id.id2name}
			end
		end_eval
	end

end

class Example
	puts "---- #{self.name}"
	puts "---- #{self.class}"
	def x
		puts "---- #{self.class}"
	end
	atr :go
	doc "This is a sample documentation string"
	# .. rest of class
end

#~ puts Module::doc(Example)
#~ puts Module::doc("Another")

e = Example.new
#~ e.go=32
#~ p e.go
e.x