require 'sendsms'
require "open-uri"
require "htmlsample"

$url = "http://www.vegvesen.no/trafikk/vegmeldinger/rapport/index.jsp?report_id=7&print=1&vegtype=Ev&vegnr=134"

$lastEdited = '<nobr>Ev 134 <\/nobr>.*?' +
              '<B>(.*?)<\/B>.*?' +
              '<br>(.*?)<br>'



def sendSMS(message)
    # Sending message
    userid = "mmendel"
    password = "a527ack"
    recipient = "41459590"
    sms = SMS.new
    sms.login(userid, password)
    sms.sendSMS(recipient, message)
end

def getLastEditedTime(msg)
    reLastEdited = %r{VEGRAPPORT - Ev 134.*?<nobr>(.*?)<\/nobr>}m
    msg.match(reLastEdited)[1] + "\n"
end

def getBody(msg)
    reLastEdited = Regexp.new($lastEdited, Regexp::MULTILINE)
    rows = msg.scan(reLastEdited)
    ret=""
    rows.each do |e|
        ret << "#{e[0].strip}\n#{e[1].strip}\n"
    end
    ret
end

def getHTMLResponse
    resp = open($url).read
    #~ $sampleHtml
end

def createMessage
    resp = getHTMLResponse
    getLastEditedTime(resp) + getBody(resp)
end


loop {
    puts Time.now
    msg = createMessage
    puts msg
    sendSMS(msg)
    sleep(1*60*60) # Send a message every hour.
}

