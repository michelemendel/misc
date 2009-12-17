#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
@layout = Qt::HBoxLayout.new

@sublayout = Qt::VBoxLayout.new
@w1 = QWidget.new
@w2 = QWidget.new
@w3 = QWidget.new

@sublayout.addWidget(w1)
@sublayout.addWidget(w2)

@layout.addLayout(@sublayout)
@layout.addWidget(@w3)
