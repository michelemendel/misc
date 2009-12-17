# ====================================================================
# Continuation Examples
# Author: Jim Weirich (jweirich@one.net)
# ====================================================================

# --------------------------------------------------------------------
# Simple Producer/Consumer
# --------------------------------------------------------------------
# Connect a simple counting task and a printing task together using
# continuations.
#
# Usage:  count(limit)

def count_task(count, consumer)
    (1..count).each do |i|
        callcc {|cc| consumer.call(cc, i) }
        puts "."
    end
    nil
end

def print_task()
    producer, i = callcc { |cc| return cc }
    print "#{i} "
    callcc { |cc| producer.call }
end

def count(limit)
    pt = print_task()
    count_task(limit, pt)
    puts
end

count(4)
        #~ ---->
        #~ Continuation
        #~ Fixnum
        #~ 99 

#~ x = print_task()
#~ x.call
#~ def x
    #~ producer, i = callcc { |cc| return cc }
    #~ puts producer.class, i.class
#~ end

#~ x


# --------------------------------------------------------------------
# Filtering Out Multiples of a Given Number
# --------------------------------------------------------------------
# Create a filter that is both a consumer and producer.  Insert it
# between the counting task and the printing task.
# 
# Usage:  omit (2, limit)

def filter_task(factor, consumer)
  producer, i = callcc { |cc| return cc }
  if(i%factor) != 0 then
    callcc { |cc| consumer.call cc, i }
  end
  producer.call
end

def omit(factor, limit)
  printer = print_task()
  filter = filter_task(factor, printer)
  count_task(limit, filter)
  print "\n"
end


# --------------------------------------------------------------------
# Prime Number Generator
# --------------------------------------------------------------------
# Create a prime number generator.  When a new prime number is
# discovered, dynamically add a new multiple filter to the chain of
# producers and consumers.
#
# Usage:  primes (limit)

def prime_task(consumer)
  producer, i = callcc { |cc| return cc }
  if i >= 2 then
    callcc { |cc| consumer.call cc, i }
    consumer = filter_task(i, consumer)
  end
  producer.call
end

def primes(limit)
  printer = print_task()
  primes = prime_task(printer)
  count_task(limit, primes)
  print "\n"
end