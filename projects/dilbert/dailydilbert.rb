require 'open-uri'
require 'date'
require 'net/smtp'

include Net

def send_confirmation_mail
    smtpserver = "ast-wt02.mobil.telenor.no"
    domain = "ast-wt02"
    from = "michele.mendel@telenor.com"
    to = ["mmendel@online.no"]    
    time = Time.now.strftime("%Y.%d.%m-%H:%M")
    
    msg = ""
    msg += "From: Michele Mendel <#{from}>\n"
    msg += "To: #{to}\n"
    msg += "Subject: Dilbert successfully downloaded at #{time}\n"
    msg += "Date: #{time}\n"
    msg += "\n"
    msg += "Dilbert successfully downloaded.\n"
    
    puts msg
    
    SMTP.start(smtpserver, 25, domain) do |smtp|
        res = smtp.send_message(msg, from, to)
        puts res
    end
end


$downloadDir = 'C:/MM/Ent/Pics/Cartoon/Dilbert/2005/'

def downloadDilbert(date = Date.today, sendmail = true)
    dateInFile = date.strftime('%Y%m%d')
    filetype = 0==date.wday ? "jpg" : "gif" #Sunday is jpg day
    dilbertImgName = "dilbert#{dateInFile}.#{filetype}"

    baseUrl = 'http://www.dilbert.com'
    dilbertUri = "/comics/dilbert/archive/dilbert-#{dateInFile}.html"
    reDilbertImgUrl = /\/comics\/dilbert\/archive\/images\/dilbert.*?\.#{filetype}/
    
    begin
        resp = open(baseUrl + dilbertUri).read
    
        dilbertImgUrl = baseUrl + resp.match(reDilbertImgUrl)[0]
        dilbertImgData = open(dilbertImgUrl).read
    
        file = File.new($downloadDir+dilbertImgName, "wb")
        file.print(dilbertImgData)
        file.flush
        
        puts "Downloaded #{dilbertImgName} to #{$downloadDir} at #{date.strftime('%Y%m%d-%H:%M')}"
        send_confirmation_mail if sendmail
    rescue => status
        puts status
    end
end

#~ downloadDilbert

#~ # Manually download
22.upto(22){ |d|
    downloadDilbert(Date.new(2005,12,d), true)
}

