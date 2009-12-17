

    pr = lambda{puts "Coming from a Proc"}

    def instev(closure=nil, &block)
        if(block_given?)
            puts "Block"
            instance_eval(&block)
            block.call
        end
        
        if(closure.kind_of?(Proc))
            puts "Proc"
            closure.call
            instance_eval(&closure)
        end
    end
    instev(pr)
    puts "-"*30
    instev(){puts "Coming from a Block"}
    puts "-"*30
    instev(pr){puts "Coming from a Block"}
    
    
   
    
#--------------------------------------------------------------    
    
    #~ def q(cl=nil, &bl)
        #~ puts "Block"            if(block_given?)
        #~ puts bl.class           if(block_given?)
        #~ puts bl.kind_of?(Proc)  if(block_given?)
        
        #~ puts "No Block"         if(cl.kind_of? Proc)
        #~ puts cl.class           if(cl.kind_of? Proc)
        #~ puts cl.kind_of?(Proc)  if(cl.kind_of? Proc)
    #~ end
    
    #~ q(){}
    #~ puts
    #~ pr = proc{}
    #~ q(pr){}