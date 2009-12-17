
# Changes Array's sort method.

class Array
	alias oldSort sort
	def sort
        re = /^the /
		oldSort{|x,y|
            xx = x.downcase.sub(re,'')
            yy = y.downcase.sub(re,'')
            xx  <=> yy
		}
	end
end