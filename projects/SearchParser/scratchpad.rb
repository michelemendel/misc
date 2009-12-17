
# 
# === Search parser
#
# Author:: Michele Mendel
# Date:: Oslo 2005-??-??
# Version:: 1.0
#
# Extract the age and calculate the
# date of birth.
#
# Book:: Programming Language Processors in Java: Compilers and Interpreters
# Amazon:: http://www.amazon.com/exec/obidos/tg/detail/-/0130257869/qid=1129048554/sr=8-1/ref=pd_bbs_1/102-2208931-4360169?v=glance&s=books&n=507846
#
# ==== EBNF GRAMMAR
# expression = term ('OR' term)* \n
# term = factor | ('AND'(empty|'NOT') factor)* <br/>
# factor = searchstring | '('expression')' <br/>
#


#~ inputs = %w{d}
#~ inputs << 2 << 99

#~ inputs.each{ |inp|
    #~ puts "#{inp}   #{inp.class}"
    #~ case inp
        #~ when /d/
            #~ puts "DEBUG 2"
        #~ when "d"
            #~ puts "DEBUG"
        #~ when /\d/
            #~ puts "digit is #{inp}"
        #~ when "q", "x", 99
            #~ puts "EXIT"
        #~ else
            #~ puts "Illegal command: #{inp}"
    #~ end
#~ }


s = '!'
s.downcase!
puts s
