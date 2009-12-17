#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Korundum'

class SlotWidget < KDE::Dialog
  k_dcop 'void mySlot(QSize)'

  def initialize(parent=nil, name=nil)
    super(parent,name)
  end

  def mySlot(size)
    puts "mySlot called #{size}"
    dispose
  end
end

about = KDE::AboutData.new("remote", 
  "Remote", "1.0")
KDE::CmdLineArgs.init(ARGV, about)
a = KDE::Application.new()
w = SlotWidget.new(nil)
w.connectDCOPSignal("appname","SignalWidget",
  "mySizeSignal(QSize)", "mySlot(QSize)",
  false)
a.setMainWidget(w)
a.exec
 




