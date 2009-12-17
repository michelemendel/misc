require 'net/http'

h = Net::HTTP.new('www.cnn.com', 80)

#resp, data = h.get('/_gfx/campaign/416x116_1q03_en.gif', nil)
resp, data = h.get('http://i.cnn.net/cnn/2003/images/05/08/top.main.sars.guards.ap.jpg', nil)

if resp.message=="OK"
	print resp.code, ": ", resp.message
	File.new("image.jpg", "wb").puts data
	#data.scan(/<img src="(.*?)"/) { |image| puts image }
	#puts data
elsif
	print resp.code, ": ", resp.message
end