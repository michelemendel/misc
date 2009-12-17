
require 'net/smtp'
require 'date'

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
    
    #~ SMTP.start(smtpserver, 25, domain) do |smtp|
        #~ res = smtp.send_message(msg, from, to)
        #~ puts res
    #~ end
end



send_confirmation_mail