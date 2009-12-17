require "fox"

include Fox

class SimpleMessageHandlerWindow < FXMainWindow

	def initialize(app)
		super(app, "Simple Message Handler")

		aButton = FXButton.new(self, "&Helllllllllllllllllllllllllllllllllllllllllllo, World")
		aButton.connect(SEL_COMMAND, method(:onCmdHelloWorld))
	end

	def onCmdHelloWorld(sender, sel, ptr)
			puts "Hello, World"
			$stdout.flush
	end
end

def run
	application = FXApp.new
	#~ application.init(ARGV)
	main = SimpleMessageHandlerWindow.new(application)

	application.create
	main.show(PLACEMENT_SCREEN)
	application.run
end

run
