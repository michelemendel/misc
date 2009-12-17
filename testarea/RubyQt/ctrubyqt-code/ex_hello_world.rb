#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'                                      #<callout id="co.hello_world.require"/>
app = Qt::Application.new(ARGV)                   #<callout id="co.hello_world.appnew"/>
label = Qt::Label.new("Hello World", nil)         #<callout id="co.hello_world.labelnew"/>
label.resize(150, 30)                             #<callout id="co.hello_world.resize"/>
app.setMainWidget(label)                          #<callout id="co.hello_world.mainwidget"/>
label.show()                                      #<callout id="co.hello_world.labelshow"/>
app.exec()                                        #<callout id="co.hello_world.exec"/>

