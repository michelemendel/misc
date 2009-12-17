def getIcon(url, icon, file)
	require 'net/http'
	include Net

	puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	puts url

	h = HTTP.new(url, 80)
	
	begin
		resp, data = h.get(icon)
		puts resp.message
		#~ resp.each{|h| puts h}
		#~ puts data.size
		#~ puts data
		if resp.message == "OK"
			out = File.new(file,"wb")
			out.write(data)
		end
	rescue => detail
		puts detail
	end
	
end

url = 'www.generation5.org'
icon = '/favicon.ico'
file = 'C:\MM\Dev\Ruby\testarea\file\favorites\icons\icon79.ico'
getIcon(url, icon, file)

#~ url = 'www.generation5.org'
#~ icon = '/favicoXn.ico'
#~ file = 'C:\MM\Dev\Ruby\testarea\file\favorites\icons\icon79.ico'
#~ getIcon(url, icon, file)

url = 'www.no-ip.com'
icon = '/favicon.ico'
file = 'C:\MM\Dev\Ruby\testarea\file\favorites\icons\icon80.ico'
getIcon(url, icon, file)





