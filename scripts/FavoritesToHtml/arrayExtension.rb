
# Changes Array's sort method.

class Array
	alias oldSort sort
	def sort
		oldSort{|x,y|
			if(x.isDir && !y.isDir)
				-1
			elsif(!x.isDir && y.isDir)
				1
			else(x.isDir && y.isDir)
				x.id <=> y.id
			
			# Doesn't seem to be needed
			#~ else
				#~ x.title.downcase <=> y.title.downcase
			end
		}
	end
end