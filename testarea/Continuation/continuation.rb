

#~ def shn
    #~ @state_handler_name ||= {}
#~ end


#~ state = :x
#~ name = "nnn"
#~ shn = {}
#~ shn[state] = name

#~ p shn




#~ def ctest1
    #~ (1..6).each { |i|
        #~ return callcc{} if i==4
        #~ puts i
    #~ }
#~ end

#~ def ctest2
    #~ callcc{ |cc|
        #~ (1..6).each { |i|
            #~ return cc if i==4
            #~ puts i
        #~ }
    #~ }
#~ end

#~ cont = ctest2
#~ cont.call


#~ def strange
    #~ puts "In method, before callcc"
    #~ callcc {|cont| return cont}
    #~ puts "In method, after callcc"
#~ end

#~ puts "Before method"
#~ cont = strange()
#~ puts "After method"
#~ cont.call if cont


def cc
    puts "do A"
    puts "----> 1. #{caller}"
    callcc { |cont| return cont}
    puts "----> 2. #{caller}"
    puts "do B"
end

puts "calling cc"
cont = cc()
if cont
    puts "doing other stuff"
    cont.call()
end
puts "end of work"
puts


# "return"
#~ def inv(v)
  #~ callcc{|myreturn|
    #~ p "doing things"
    #~ myreturn.call(0) if v == 0	# special case for v = 0
    #~ p "otherwise doing other things"
    #~ 1.0 / v
  #~ }
#~ end

#~ inv 0

#~ # "goto"
#~ p "doing things"
#~ label_here = nil
#~ # creating a label here
#~ callcc{|k| label_here = k}
#~ p "doing other things"
#~ label_here.call
#~ p "this won't be reached"


#~ # "goto" v.2
#~ def mygoto(continuation)
  #~ continuation.call(continuation)
#~ end

#~ p "doing things"
#~ label_here = callcc{|k| k}
#~ p "doing other things"
#~ mygoto(label_here)
#~ p "this won't be reached"







