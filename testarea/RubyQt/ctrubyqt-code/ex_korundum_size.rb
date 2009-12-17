#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---

require 'Korundum'

class MyWidget < KDE::Dialog
  k_dcop 'QSize mySize()'

  def initialize(parent=nil, name=nil)
    super(parent,name)
  end

  def mySize()
    return size()
  end
end



about = KDE::AboutData.new("app1", "MyApplication", "1.0")
KDE::CmdLineArgs.init(ARGV, about)
a = KDE::Application.new()
w = MyWidget.new
a.dcopClient.registerAs("app1",false)
a.setMainWidget(w)
w.show
a.exec

