#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.4
# from racc grammer file "calc.y".
#

require 'racc/parser'



# calc.rb : generated by racc


class Calcp < Racc::Parser

module_eval <<'..end calc.y modeval..id2ce6084413', 'calc.y', 35
  
  def parse( str )
    @q = []

    while str.size > 0 do
      case str
      when /\A\s+/o
      when /\A\d+/o
        @q.push [:NUMBER, $&.to_i]
      when /\A.|\n/o
        s = $&
        @q.push [s, s]
      end
      str = $'
    end
    @q.push [false, '$end']

    do_parse
  end

  def next_token
    s = @q.shift
  end


..end calc.y modeval..id2ce6084413

##### racc 1.4.4 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 1, 11, :_reduce_none,
 0, 11, :_reduce_2,
 3, 12, :_reduce_3,
 3, 12, :_reduce_4,
 3, 12, :_reduce_5,
 3, 12, :_reduce_6,
 3, 12, :_reduce_7,
 2, 12, :_reduce_8,
 1, 12, :_reduce_none ]

racc_reduce_n = 10

racc_shift_n = 19

racc_action_table = [
     7,     8,     9,    10,     6,    18,     3,     4,    11,     5,
     7,     8,     9,    10,     3,     4,    13,     5,     3,     4,
   nil,     5,     3,     4,   nil,     5,     3,     4,   nil,     5,
     3,     4,   nil,     5,     7,     8,     7,     8 ]

racc_action_check = [
    12,    12,    12,    12,     1,    12,    10,    10,     3,    10,
     2,     2,     2,     2,     0,     0,     6,     0,     4,     4,
   nil,     4,     9,     9,   nil,     9,     8,     8,   nil,     8,
     7,     7,   nil,     7,    17,    17,    16,    16 ]

racc_action_pointer = [
     8,     4,     7,    -1,    12,   nil,    16,    24,    20,    16,
     0,   nil,    -3,   nil,   nil,   nil,    33,    31,   nil ]

racc_action_default = [
    -2,   -10,    -1,   -10,   -10,    -9,   -10,   -10,   -10,   -10,
   -10,    -8,   -10,    19,    -5,    -6,    -3,    -4,    -7 ]

racc_goto_table = [
     2,     1,   nil,   nil,    12,   nil,   nil,    14,    15,    16,
    17 ]

racc_goto_check = [
     2,     1,   nil,   nil,     2,   nil,   nil,     2,     2,     2,
     2 ]

racc_goto_pointer = [
   nil,     1,     0 ]

racc_goto_default = [
   nil,   nil,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 :UMINUS => 2,
 "*" => 3,
 "/" => 4,
 "+" => 5,
 "-" => 6,
 "(" => 7,
 ")" => 8,
 :NUMBER => 9 }

racc_use_result_var = true

racc_nt_base = 10

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'UMINUS',
'"*"',
'"/"',
'"+"',
'"-"',
'"("',
'")"',
'NUMBER',
'$start',
'target',
'exp']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

module_eval <<'.,.,', 'calc.y', 14
  def _reduce_2( val, _values, result )
 result = 0
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 17
  def _reduce_3( val, _values, result )
 result += val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 18
  def _reduce_4( val, _values, result )
 result -= val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 19
  def _reduce_5( val, _values, result )
 result *= val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 20
  def _reduce_6( val, _values, result )
 result /= val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 21
  def _reduce_7( val, _values, result )
 result = val[1]
   result
  end
.,.,

module_eval <<'.,.,', 'calc.y', 22
  def _reduce_8( val, _values, result )
 result = -val[1]
   result
  end
.,.,

 # reduce 9 omitted

 def _reduce_none( val, _values, result )
  result
 end

end   # class Calcp


parser = Calcp.new
count = 0
scnt  = 0

puts
puts 'type "Q" to quit.'
puts

while true do
  puts
  print '? '
  str = gets.chop!
  break if /q/i === str

  begin
    val = parser.parse( str )
    print '= ', val, "\n"
  rescue ParseError
    puts $!
  rescue
    puts 'unexpected error ?!'
    raise
  end

end
