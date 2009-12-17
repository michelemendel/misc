
require 'parsedate'
require 'date'

#~ include ParseDate

t_now = Time.now
#~ dt_now = DateTime.now
p t_now
#~ p dt_now

t = ParseDate::parsedate(t_now.to_s)
p t