


class Bs

	def initialize()
	end
	
	def cf(file)
		f = File.open(file)

		#~ f.each do |line| 
			#~ puts line;
		#~ end

		f.each("\s") do |line| 
			if (line =~ /aktuell.*/i)
				puts $&;
			end
		end
	end
end






