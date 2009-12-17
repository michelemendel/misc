require 'socket'

port = 80
url = 'localhost'

server = TCPServer.new(url, port)

while(session = server.accept)
	#~ puts "-------------------"
	#~ while(line=session.gets)
		#~ puts line
	#~ end
	#~ session.print "HTTP/1.1 200/OK\r\nContent-type: text/html\r\n\r\n"
	#~ session.print "<html><body><h1>#{Time.now}</h1></body></html>\r\n"
	
	#~ print "Request: #{session.gets}"
	#~ puts "Request: #{session.readlines}"
	#~ session.puts Time.now
	#~ session.close

	Thread.new(session) do |s|
		print(s,  " is accepted\n")
		while (line = s.gets)
		  puts(line)
		end
		print(s, " is gone\n")
		#~ puts "Request: #{s.gets}"
		s.puts(Time.now)
		s.close
	end
end

