require 'socket'
require 'pp'

$CRLF = "\r\n"
$SP = " "
$REQUEST = "REQUEST"
$RESPONSE = "RESPONSE"

class SMS
    @@httpVersion = "HTTP/1.1"
    @@url = "epost.telenor.no"
    @@requestURI = "/mobileoffice/"
    @@headers  = [
            "Content-Type: application/x-www-form-urlencoded",
            "User-Agent: RMM",
            "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.5) Gecko/20041217",
            "Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,image/jpeg,image/gif;q=0.2,*/*;q=0.1",
            "Accept-Language: en-us,en;q=0.5",
            "Accept-Encoding: gzip,deflate", 
            "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7",
            "Connection: close"
          ]

    attr :loginOk

    def initialize(verbose=false, onlyHeader=true)
        @cookie = ""
        @verbose = verbose
        @onlyHeader = onlyHeader
        @loginOk = false
    end
    
    def login(userid, password)
        urlParams = "cmd=login&userid=#{userid}&password=#{password}"
        resp = post(urlParams)
        respLabel, respMsg = getErrorMsg(resp)
        
        # 302-REDIRECT - GET
        if(respLabel=="Feilmelding")
            #~ puts("#{respLabel}:\n#{respMsg}")
        else
            @loginOk = true
            reParams = /Location: http:\/\/#{@url}#{@requestURI}(.*)$/
            reCookie = /Set-Cookie: (.*);/
            reJsessionid = /(;jsessionid=.*)\?/
            
            urlParams = resp.match(reParams)[1].chomp
            @cookie = resp.scan(reCookie).join(";")
            jsessionid = resp.match(reJsessionid)[1].chomp
            get(urlParams)
        end
        
        return @loginOk
    end
    
    #
    def post(urlParams)
        httpSend("POST", @cookie, urlParams)
    end

    #
    def get(urlParams)
        cookie = @cookie.empty? ? "" : @cookie
        httpSend("GET", @cookie, urlParams)
    end

    #
    def httpSend(method, cookie, urlParams)
        urlParams = urlParams.empty? ? "" : "?" + urlParams
        requestURI = @@requestURI + urlParams
        requestLine = method + $SP + requestURI + $SP + @@httpVersion
        cookie = cookie.empty? ? "" : $CRLF + "Cookie: " + cookie
        
        header = "Host: #{@@url}" + $CRLF + @@headers.join($CRLF) +
                 $CRLF + cookie
        
        request = requestLine + $CRLF + header + $CRLF #+ $CRLF
        socket = TCPSocket.open(@@url, 80)
        socket.send(request, 0)
        response = socket.read
        socket.close
        return response
    end

    #
    def getHeader(page)
        re = /(HTTP.*?\r\n\r\n)/m
        m = page.match(re)
        return m[1] unless !m
    end

    #
    def getHtml(page)
        re = /(<HTML>.*<\/HTML>)/mi
        m = page.match(re)
        return m[1] unless !m
    end

    #
    def getErrorMsg(page)
        reLabel = /<td class="errormessage-label">(.*?)</
        reMsg = /<td class="errormessage-text">(.*?)</m
        label = page.match(reLabel)
        msg = page.match(reMsg)
        if(label==nil || msg==nil)
            return "", ""
        else
            return label[1], msg[1]
        end
    end
end
