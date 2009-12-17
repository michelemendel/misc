require 'rinda/tuplespace'
require 'monitor'
require 'singleton'

include Rinda

puts "Starting Mike"

class Seq < Monitor
    include Singleton
    
    def initialize
        @carNr = 0
        @orderNr = 0
    end
    
    def getCarNr
        @carNr += 1
    end
    
    def getOrderNr
        @orderNr += 1
    end
end

class Producer
    def initialize(tupleSpace)
        @ts = tupleSpace
        @seq = Seq.instance
    end
    
    def produce(nr)
        action, orderNr = @ts.take ['order', Numeric]
        puts "\t<-- P#{nr}: received order #{orderNr}"
        
        carNr = @seq.getCarNr
        
        sleep 1 # Working on the ordered car
        
        puts "\t\tP#{nr}: car nr #{carNr} produced from order #{orderNr}"
        
        @ts.write ['car', carNr, orderNr]
        puts "\t\t\t--> P#{nr}: delivered car #{carNr} from order #{orderNr}"    
    end    
end

class Consumer
    def initialize(tupleSpace)
        @ts = tupleSpace
        @seq = Seq.instance
    end

    def consume(nr)
        orderNr = @seq.getOrderNr
        sleep 1 # Working on an order
        
        @ts.write ['order', orderNr]
        puts "--> C#{nr}: sent order #{orderNr}"
        
        object, carNr, orderNr = @ts.take [String, Numeric, Numeric]
        puts "\t\t\t\t<-- C#{nr}: received #{object} #{carNr} from order #{orderNr}"    
    end
end

class Main
    def start
        ts = TupleSpace.new
        
        ps = []
        cs = []
        3.times do |nr|
            ps << Thread.new(nr) { |nr|
                pro = Producer.new(ts)
                loop do
                    pro.produce(1)
                end
            }
        end
        
        4.times do |nr|
            cs << Thread.new(nr) { |nr|
                con = Consumer.new(ts)
                loop do
                    con.consume(nr) 
                end
            }

        end
        ps.each{|p| p.join}
        cs.each{|c| c.join}
    end
end

Main.new.start