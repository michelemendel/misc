#- REXML -------------------------------
require "rexml/document"
require "rexml/streamlistener"
include REXML

#- XMLParser -------------------------------
require "xml/saxdriver"
include XML::SAX
include Helpers

iTunesFile = "lib.xml"
iTunesFile = "liblight.xml"

#- XMLParser -------------------------------
class TestHandler < HandlerBase
    def getAttrs(attrs)
        #~ ret = []
        #~ for i in 0...attrs.getLength
            #~ ret .push([attrs.getName(i), attrs.getValue(i)])
        #~ end
        #~ ret
    end
    
    def startElement(name, attr)
        #~ p ["startElement", name, getAttrs(attr)]
    end
    
    def endElement(name)
        #~ p ["endElement", name]
    end
    
    def characters(ch, start, length)
        #~ p ["characters", ch[start, length]]
    end
end

#- REXML -------------------------------
class Handler
    include StreamListener
    def tag_start(name, attrs)
        #~ p ["startElement", name]
        #~ if name=="key"
            #~ puts name
        #~ end
    end
    
    def tag_end(name)
        #~ p ["endElement", name]
        #~ if name=="key"
            #~ puts name
        #~ end
    end

    def text(text)
        #~ p ["characters", text]
        #~ puts text
    end
end


#- XMLParser -------------------------------
xpStart = Time.now
p = ParserFactory.makeParser("XML::Parser::SAXDriver")
p.setDocumentHandler(TestHandler.new)
p.parse(iTunesFile)
xpEnd = Time.now
puts "XMLParser time = #{xpEnd - xpStart}"

#- REXML -------------------------------
#~ reStart = Time.now
#~ itf = File.new(iTunesFile)
#~ Document.parse_stream(itf, Handler.new)
#~ reEnd = Time.now
#~ puts "REXML time = #{reEnd - reStart}"


puts "ok"