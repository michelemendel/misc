

class IpAddressGen

	def initialize(iprange)
		@s = []
		@e = []
		@nofAddresses = []
		ip = iprange.split('.')
		ip.each_index{|idx|
			startEnd = ip[idx].split('-')
			@s[idx] = startEnd[0]
			@e[idx] = startEnd.length==2?startEnd[1]:startEnd[0]
			#~ puts "#{@s[idx]}-#{@e[idx]}"
			@nofAddresses[idx] = @e[idx].to_i - @s[idx].to_i + 1
		}
	end

	def getNofAddresses
		ret = 1
		@nofAddresses.each{ |n|
			ret = ret * n
		}
		ret
	end

	def eachIP
		(@s[0]..@e[0]).each{ |d1|
			(@s[1]..@e[1]).each{ |d2|
				(@s[2]..@e[2]).each{ |d3|
					#~ (@s[3]..@e[3]).each{ |d4|
						d4 = @s[3]==@e[3]?@s[3]:@s[3] + '-' + @e[3]
						yield d1.to_s + '.' + d2.to_s + '.' + d3.to_s + '.'  + d4.to_s
					#~ }
				}
			}
		}
	end

end


# Test

#~ ip1 = "148.121.10.11"
#~ ip2 = "148.121.10.11-14"
#~ ip3 = "148.121.10-15.11"
#~ ip4 = "148.121.152-153.20-30"
#~ ip5 = "148-152.121-140.10-15.0-25"

#~ iag = IpAddressGen.new(ip4)
#~ puts "nof ip addresses to scan: #{iag.getNofAddresses}"

#~ start = Time.now
#~ iag.eachIP{ |ip|
	#~ puts ip
#~ }
#~ puts "#{Time.now-start} ms"


