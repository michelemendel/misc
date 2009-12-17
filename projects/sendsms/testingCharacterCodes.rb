require 'sendsms'
require "uri"

message = "€ £ § ¤"
encShouldBe = "%E2%82%AC+%C2%A3+%C2%A7+%C2%A4"
encMessage = message.smsEncode

sMessage = message.split
sEncShouldBe = encShouldBe.split('+')
sEncMessage = encMessage.split('+')

for i in 0...sMessage.length
    puts "#{i}: #{sMessage[i]} #{sEncShouldBe[i]} #{sEncMessage[i]}"
end
