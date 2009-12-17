# 
# === Tree view of MS Windows Favorites
#
# Description:
# Creates an html file with a tree view of MS Windows favorites.
#
# Version:: 1.0
# Date:: 2004.04.22
# Location:: Oslo, Norway
#
# Author:: Michele Mendel 
# Mail:: mmendel@online.no
# Mail:: michele.mendel@telenor.com
# License::  Copyright (c) 2004 Michele Mendel.
#
# Uses dTree from http://www.destroydrop.com/javascripts/tree/.
#


require 'ftools'
require 'config'
require 'arrayExtension'
require 'node'
# Only if using icons
#~ require 'open-uri' 

include Config

class Favorites

	attr_accessor :root, :template, :outputFile, :treeTitle, :htmlTitle
	attr_accessor :dtreeJSFile, :dtreeCSSFile, :dtreeImgDir
	
	# Regex's
	Re_dir 		 = Regexp.new('.*\/(.*)')
	Re_title	 = Regexp.new('(.*)\.url')
	Re_url 		 = Regexp.new('^URL=(http.*)')
	Re_iconUrl	 = Regexp.new('^IconFile=(http.*)')
	Re_iconFile	 = Regexp.new('^.*(icons/icon\d+\.ico)')
	
	Re_htmlTitle = Regexp.new('<mm:htmlTitle/>')
	Re_tree 	 = Regexp.new('<mm:tree/>')
	

	def initialize()
		initParameters
		
		@favorites = Array.new()
		@idcount = 0
		
		@curDir 	= Dir.pwd
		@destDir 	= File.dirname(@outputFile)
		@destDirImg = @destDir + "/img"
		# Not in use
		#~ @iconsDir 	= @destDir + "/icons"
		
		File.makedirs(@destDirImg)		
	end


	# Generates the HTML file with JavaScript tree.
	def generate()
		recurseTree(@root)
		#~ downloadIcons() # For icon use
		jstree = getJavaScriptTree()
		
		Dir.chdir(@curDir)
		out = File.new(@outputFile, "w")
		IO.foreach(@template) { |line|
			line.sub!(Re_htmlTitle, @htmlTitle)
			line.sub!(Re_tree, jstree)
			out.print(line)
		}
		out.close
		
		copyAuxFiles
	end


	# 
	def recurseTree(dir, pid=0)
		if(!FileTest.directory?(dir))
			print("'#{dir}' is not a directory\n")
			return false
		end	
		
		Dir.chdir(dir)
		Dir.entries(".").each{|f|
			next if(f=="." || f=="..")
			
			subdir = dir + "/" + f			
			if(File.directory?(subdir))
				@idcount += 1
				tmpdir = (match=Re_dir.match(subdir))?match[1]:''
				@favorites.push(Node.new(true, @idcount, pid, '', tmpdir, '', ''))
				recurseTree(subdir, @idcount)
			end
			
			if(title = Re_title.match(f))
				linkContent = File.new(f).read
				if(url = Re_url.match(linkContent))
					@idcount += 1
					iconUrl = (match=Re_iconUrl.match(linkContent))?match[1]:''
					@favorites.push(Node.new(false, @idcount, pid, '', title[1], url[1], iconUrl))
				end
			end
		}
		Dir.chdir("..")
	end


	# Creates the JavaScript tree, ready to be inserted in the HTML file.
	def getJavaScriptTree()
	    js = ""
		
		js += %Q@<script type="text/javascript"><!--\n@
		js += %Q@d = new dTree('d');\n@
		js += %Q@d.add(0,-1,'#{@treeTitle}');\n@
				
		@favorites.sort.each{|link|
			if(link.isDir)
				js += %Q@d.add(#{link.id},#{link.pid},'#{link.title}','','','','img/folder.gif');\n@
			else
				# If using icons: uncomment next two lines and remove third line.
				#~ icon = "#{@iconsDir}/icon#{link.id}.ico"
				#~ icon = File.exist?(icon)?icon.sub(Re_iconFile, '\1'):''
				icon = ''
				js += %Q@d.add(#{link.id},#{link.pid},"#{link.title}",'#{link.url}','','','#{icon}');\n@
			end
		}
		js += %Q@document.write(d);\n@
		js += %Q@//--></script>@
	end


	# Copies dTree files and images to the same directory as the result file.
	def copyAuxFiles
		Dir.chdir(@curDir)
		File.copy(@dtreeJSFile, @destDir)
		File.copy(@dtreeCSSFile, @destDir)

		@destDirImg = File.expand_path(@destDirImg)
		Dir.chdir(@dtreeImgDir)
		Dir.foreach('.'){|f|
			File.copy(f, @destDirImg) unless (f=="." || f=="..")
		}
	end


	# Not in use
	#~ def getImage(url, file)
		#~ out = File.new(file, "wb")
		#~ res = open(url)
		#~ puts res
		#~ { |f| 
			#~ f.each_line {|line| out.print(line)} 
		#~ }
		#~ out.close
	#~ end

	# Not in use
	#~ def downloadIcons()
		#~ @favorites.each{ |node|
			#~ if((url = node.iconUrl)!='')
				#~ file = "#{@iconsDir}/icon#{node.id}.ico"
				#~ puts url
				#~ getImage(url, file)
			#~ end
		#~ }
	#~ end
	
end

# Run the program
favs = Favorites.new()
favs.generate



