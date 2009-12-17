

# Set properties in this file.

module Config
	def initParameters
		
		# The Favorite Directory Root
    	#@root          = 'C:\Documents and Settings\Default User\Favorites'
    	@root           = 'H:\FavData'
		
		# Use relative or absolute paths
		@template       = 'template1.html'
		@outputFile     = 'favorites/Favorites.html'
		@treeTitle      = 'My favorites'
    	@htmlTitle      = "Michele's Favorites"
		
		# This shouldn't be changed
		@dtreeJSFile    = 'dtree/dtree.js'
    	@dtreeCSSFile   = 'dtree/dtree.css'
    	@dtreeImgDir    = 'dtree/img'
		
	end
end