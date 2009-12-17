
class Module
   def foobar id
     puts "Hello Ruby: #{id}"
   end
end

class C
    #~ extend M
    #~ class << self
        #~ include M
    #~ end
    foobar :example
end
#~ C
my_c = C.new
