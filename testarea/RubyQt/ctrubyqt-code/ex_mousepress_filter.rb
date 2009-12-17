#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'

class MouseFilterWidget < Qt::Widget

  def initialize(parent=nil)
    super(parent)
    @button = Qt::PushButton.new("PushButton", self)
    @layout = Qt::VBoxLayout.new(self)
    @layout.addWidget(@button)
    @layout.addStretch(1)
   
    # Override events for the button
    @button.installEventFilter(self)
  end

  def eventFilter(obj,event)
    if(obj == @button && event.type == Qt::Event::MouseButtonPress)
      if(event.button == Qt::RightButton)
        Qt::MessageBox::information(self,"Message",
          "You right clicked the button")
        return true
      end
    end
  end

end

app = Qt::Application.new(ARGV)
mw = MouseFilterWidget.new
app.setMainWidget(mw)
mw.show
app.exec
