require 'rubygems'
require_gem 'fxruby'

include Fox

app = FXApp.new
mainWindow = FXMainWindow.new(app, "Hello")



def printMsg(msg)
	puts msg
	$stdout.flush
end

def printSomething(sender, sel, ptr)
	puts sender.class
	puts sel
	puts ptr
	#~ puts "printSomething"
	$stdout.flush
end




theButton = FXButton.new(mainWindow, "Quit")
#~ theButton.tipText = "Push Me!"

#~ iconFile = File.open("042.jpg", "rb")
#~ theButton.icon = FXJPGIcon.new(app, iconFile.read)
#~ iconFile.close
#~ theButton.iconPosition = ICON_ABOVE_TEXT
#~ theButton.icon.options = IMAGE_ALPHACOLOR | IMAGE_ALPHAGUESS

theButton.connect(SEL_COMMAND) { |sender, selector, data|
	#~ puts sender.class
	#~ puts selector
	#~ puts data
	exit
}


aButton = FXButton.new(mainWindow, "Push Me")
aButton.connect(SEL_COMMAND, method(:printSomething))
#~ {
	#~ printMsg("ouch")
	#~ puts "Ouch!"
	#~ $stdout.flush
#~ }


#~ FXTooltip.new(app)
app.create
mainWindow.show(PLACEMENT_SCREEN)
app.run










