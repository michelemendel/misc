require 'pp'
require 'open-uri'
require "rexml/document"

include REXML
include Net

# http://www.mp3tunes.com/api/OboeAPI.html
class Mp3tunes
    plus = "%2B"
    
    #
    def initialize
        @login_base_url = "https://shop.mp3tunes.com/"
    end

	#
    def login_url(un, pw)
        "api/v0/login?username=#{un}&password=#{pw}&partner_token=#{@pt}&output=xml" 
    end

	#
    def account_data_url
        "http://ws.mp3tunes.com/api/v0/accountData?sid=#{@sid}&output=xml"
    end

	# type = artist, album, track, playlist
    def locker_data_params(params)
    	ret = ""
    	params.each { |k,v| ret << "&#{k}=#{v}" }
    	ret    	
    end

	#
    def locker_data_url(params)
        "http://ws.mp3tunes.com/api/v0/lockerData?sid=#{@sid}&partner_token=#{@pt}&output=xml" + locker_data_params(params)
    end

	#
    def login(un, pw, pt)
        @pt = pt
        
        res = open(@login_base_url + login_url(un, pw)).read
        
        xml_str = Document.new(res)
        
        status = xml_str.elements["//status']"].text        
        if(status == "0")
        	puts xml_str.elements["//errorMessage']"].text
        	exit
        else
	        @sid = xml_str.elements["//session_id']"].text
			puts "Login OK"
        end
    end
    
    def account
    	res = open(account_data_url).read
	end
	
	def locker(params)
		pp locker_data_url(params)
		puts
        # res = open(locker_data_url(params)).read
	end

end



















# pt = 9999999999
pt = 7557872651
un = "michelemendel@gmail.com"
pw = "chagat%2B7"

m = Mp3tunes.new
m.login(un, pw, pt)
pp m.locker(:type => "track", :album_id => "516357") #, :artist_id => "5954")







# Transport endpoint is not connected
# A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using a sendto call) no address was supplied.

