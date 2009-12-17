#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---

require 'Korundum'

class SignalWidget < KDE::Dialog
  k_dcop_signals 'void mySizeSignal(QSize)' 
  slots 'timerSlot()'

  def initialize(parent=nil, name=nil)
    super(parent,name)
    t = Qt::Timer.new(self)
    connect(t, SIGNAL('timeout()'), self,
      SLOT('timerSlot()') )
    t.start(5000)
  end

  def timerSlot
    puts "emitting signal"
    emit mySizeSignal(size())  
  end
end



about = KDE::AboutData.new("appname", 
  "MyApplication", "1.0")
KDE::CmdLineArgs.init(ARGV, about)
a = KDE::Application.new()
w = SignalWidget.new
a.dcopClient.registerAs("appname",false)
a.setMainWidget(w)
w.show
a.exec
