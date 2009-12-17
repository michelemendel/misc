
# Defines a node for the tree.
#
# Note: iconUrl is not used.

class Node
	attr_reader :isDir, :id, :pid, :dir, :title, :url, :iconUrl
	
	def initialize(isDir, id, pid, dir, title, url, iconUrl)
		@isDir = isDir
		@id = id
		@pid = pid
		@dir = dir
		@title = title
		@url = url
		@iconUrl = iconUrl
	end
end