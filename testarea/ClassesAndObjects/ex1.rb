class Module
	@@docs = Hash.new(nil)
	def doc(str)
		puts "calling def doc(str)"
		@@docs[self.name] = str
	end

	def Module::doc(aClass)
		puts "calling Module::doc(aClass)"
		# If we're passed a class or module, convert to string
		# ('<=' for classes checks for same class or subtype)
		aClass = aClass.name if aClass.type <= Module
		@@docs[aClass] || "No documentation for #{aClass}"
	end
end

class Example
	puts "start class Example"
	doc "This is a sample documentation string"
	# .. rest of class
	puts "end class Example"
end

module Another
	puts "start module Another"
	doc <<-edoc
		And this is a documentation string
		in a module
	edoc
	# rest of module
	puts "end module Another"
end

puts "start testing"
puts Module::doc(Example)
puts Module::doc("Another")
puts "end testing"
