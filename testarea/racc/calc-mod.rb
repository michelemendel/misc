#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.4
# from racc grammer file "calc-mod.y".
#

require 'racc/parser'



# calc.rb : generated by racc


class Calcp < Racc::Parser

module_eval <<'..end calc-mod.y modeval..id32e375a9ed', 'calc-mod.y', 33
  
  def parse( str )
    @q = []

    while str.size > 0 do
      case str
      when /\A.+/o
        @q.push [:TOKEN, $&]
      end
      str = $'
    end
    @q.push [false, '$end']

    do_parse
  end

  def next_token
    @q.shift
  end


..end calc-mod.y modeval..id32e375a9ed

##### racc 1.4.4 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 1, 9, :_reduce_none,
 0, 9, :_reduce_2,
 3, 10, :_reduce_3,
 3, 10, :_reduce_4,
 3, 10, :_reduce_5,
 1, 10, :_reduce_none ]

racc_reduce_n = 7

racc_shift_n = 13

racc_action_table = [
     7,     8,     1,     9,     2,     1,     1,     2,     2,     1,
    10,     2,     7,     8,     6 ]

racc_action_check = [
     5,     5,     0,     5,     0,     8,     7,     8,     7,     1,
     6,     1,     4,     4,     3 ]

racc_action_pointer = [
    -3,     4,   nil,    14,     9,    -3,    10,     1,     0,   nil,
   nil,   nil,   nil ]

racc_action_default = [
    -2,    -7,    -6,    -7,    -1,    -7,    -7,    -7,    -7,    -5,
    13,    -3,    -4 ]

racc_goto_table = [
     4,     5,     3,   nil,   nil,   nil,   nil,    11,    12 ]

racc_goto_check = [
     2,     2,     1,   nil,   nil,   nil,   nil,     2,     2 ]

racc_goto_pointer = [
   nil,     2,     0 ]

racc_goto_default = [
   nil,   nil,   nil ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 && => 2,
 "AND" => 3,
 "OR" => 4,
 "(" => 5,
 ")" => 6,
 :TOKEN => 7 }

racc_use_result_var = true

racc_nt_base = 8

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
'AND',
'"AND"',
'"OR"',
'"("',
'")"',
'TOKEN',
'$start',
'target',
'exp']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

 # reduce 1 omitted

module_eval <<'.,.,', 'calc-mod.y', 16
  def _reduce_2( val, _values, result )
 result = ""
   result
  end
.,.,

module_eval <<'.,.,', 'calc-mod.y', 18
  def _reduce_3( val, _values, result )
 result << val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc-mod.y', 19
  def _reduce_4( val, _values, result )
 result << val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'calc-mod.y', 20
  def _reduce_5( val, _values, result )
 result << val[1]
   result
  end
.,.,

 # reduce 6 omitted

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
    print '=> ', val, "\n"
  rescue ParseError
    puts $!
  rescue
    puts 'unexpected error ?!'
    raise
  end

end
