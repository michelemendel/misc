require 'socket'
require 'pp'

# http://www.faqs.org/rfcs/rfc2616.html

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
            #~ "Keep-Alive: 1",
            #~ "Proxy-Connection: keep-alive",
            #~ "Connection: keep-alive"
            "Connection: close"
          ]

    def initialize(verbose=false, onlyHeader=true)
        @cookie = ""
        @verbose = verbose
        @onlyHeader = onlyHeader
        @loginOk = false
    end
    
    def login(userid, password)
        urlParams = "cmd=login&userid=#{userid}&password=#{password}"
        resp = post(urlParams, [])
        
        respLabel, respMsg = getErrorMsg(resp)
        
        # 302-REDIRECT - GET
        if(respLabel=="Feilmelding")
            puts("#{respLabel}:\n#{respMsg}")
        else
            @loginOk = true
            reParams = /Location: http:\/\/#{@url}#{@requestURI}(.*)$/
            reCookie = /Set-Cookie: (.*);/
            reJsessionid = /(;jsessionid=.*)\?/
            
            urlParams = resp.match(reParams)[1].chomp
            @cookie = resp.scan(reCookie).join(";")
            jsessionid = resp.match(reJsessionid)[1].chomp
            get(urlParams, [])    
        end
    end
    
    def sendSMS(recipient, message)
        if(@loginOk)
            urlParams = "cmd=sms&smsheader=mmendel&recipient=#{recipient}&message=#{message.smsEncode}&sub=send"
            resp = post(urlParams, [])
            respLabel, respMsg = getErrorMsg(resp)
            puts("#{respLabel}:\n#{respMsg}")
            
        end
    end

    #
    def post(urlParams, requestParams)
        httpSend("POST", @cookie, urlParams, requestParams)
    end

    #
    def get(urlParams, requestParams)
        cookie = @cookie.empty? ? "" : @cookie
        httpSend("GET", @cookie, urlParams, requestParams)
    end

    #
    def httpSend(method, cookie, urlParams, requestParams)
        urlParams = urlParams.empty? ? "" : "?" + urlParams
        requestURI = @@requestURI + urlParams
        requestLine = method + $SP + requestURI + $SP + @@httpVersion
        requestParams = requestParams.empty? ? "" : requestParams.join("&")
        cookie = cookie.empty? ? "" : $CRLF + "Cookie: " + cookie
        
        header = "Host: #{@@url}" + $CRLF + @@headers.join($CRLF) +
                 $CRLF + "Content-Length: #{requestParams.length}" +
                 cookie
        
        request = requestLine + $CRLF + 
                  header + $CRLF + $CRLF +
                  requestParams

        log($REQUEST, request)
        
        socket = TCPSocket.open(@@url, 80)
        socket.send(request, 0)
        response = socket.read
        socket.close
        log($RESPONSE, response)

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
    def writeFile(fileName, content)
        File.open(fileName,"w") {|f|
            f.print(getHtml(content))
        }
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

    def log(type, reqOrRes)
        if(@verbose)
            if(reqOrRes.empty?)
                msg = "NO RESPONSE"
            elsif($REQUEST==type)
                msg = reqOrRes
            elsif(@onlyHeader)
                msg = getHeader(reqOrRes)
            else
                msg = reqOrRes
            end
            msg = "\n--- #{type} ---\n#{msg}\n--- /#{type} ---"
            puts(msg)
        end
    end

end

class String
    def smsEncode
        ret = ""
        self.each_byte{|char|
            case char
                when 0x20
                    ret << '+'
                when 0xA
                    ret << '%0D%0A'
                when 0x00..0x2C
                    ret << "%%%02X" % char
                when 0x3A..0x3F
                    ret << "%%%02X" % char
                when 0x5B..0x60 
                    ret << "%%%02X" % char
                when 0x7B..0x7F
                    ret << "%%%02X" % char
                when 0x80..0xA7
                    ret << "%C2%" + "%X" % char
                when 0xA8..0xFF
                    nc = char - 64
                    ret << "%C3%" + "%X" % nc
                else
                    ret << char
            end
        }
        return ret
    end
end
