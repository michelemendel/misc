
require 'net/http'

$baseUrl = "www.gulasidorna.se"
$fileName = "C:/MM/Dev/Ruby/optiker.txt"

startVal = 25
stopVal = 225 #975
stepVal = 25
prePath = "/query?what=yp&stq="
postPath = "&heading_exact=Optiker,+optiska+artiklar+-+Legitimerade+optiker"
specialPath = "/query?what=yp&heading_exact=Optiker,+optiska+artiklar+-+Legitimerade+optiker&district_name=&district_type="


class OptikerScanner

	def initialize(baseUrl, fileName)
		@baseUrl = baseUrl
		@host = Net::HTTP.new(@baseUrl, 80)
		@file = File.new(fileName, "w")
	end
	
	def scanPage(path)
		@file.puts path
		printf "Scanning %s\n", path
		resp, data = @host.get(path, nil)
		
		if resp.message=="OK"
			printf "%s: %s\n", resp.code,  resp.message
			res = data.scan(/<b>(.*?)<\/b>/)
			0.step(res.length, 2) { |i| @file.printf "%-55s%s\n", res[i], res[i+1] }
		elsif
			print resp.code, ": ", resp.message
		end
	end
	
end

opt = OptikerScanner.new($baseUrl, $fileName)
opt.scanPage(specialPath)
startVal.step(stopVal, stepVal) { |i| opt.scanPage(prePath + i.to_s + postPath) }




