

module M
    module InstanceMethods
        def inst_pudding(id)
            puts "Eat up your meet #{id}"
        end
    end
    module ClassMethods
        def class_struggle(id)
            puts "Hello #{id}"
        end
    end

    def self.included(other)
        other.module_eval{
            include(InstanceMethods) 
        }
        other.extend(ClassMethods)
    end
end

class C
    include M
    class_struggle :Kalle
end

c = C.new
c.inst_pudding(:Nisse)
puts
puts "Responds to class method class_struggle: #{C.respond_to?(:class_struggle)}"
puts "Responds to instance method inst_pudding: #{c.respond_to?(:inst_pudding)}"



#~ module M
    #~ def foobar id
        #~ puts "Hello Ruby: #{id}"
    #~ end
#~ end

#~ class C
    #~ extend M
    #~ foobar :example
#~ end 