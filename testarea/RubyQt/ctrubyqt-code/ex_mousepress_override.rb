#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'

class MouseWidget < Qt::Widget

  def initialize(parent=nil)
    super(parent)
    @button = Qt::PushButton.new("PushButton", self)
    @layout = Qt::VBoxLayout.new(self)
    @layout.addWidget(@button)
    @layout.addStretch(1)
  end

  def mousePressEvent(event)
    if(event.button == Qt::RightButton)
      Qt::MessageBox::information(self,"Message",
        "You clicked the widget")
    else
      event.ignore
    end
  end

end

app = Qt::Application.new(ARGV)
mw = MouseWidget.new
app.setMainWidget(mw)
mw.show
app.exec
