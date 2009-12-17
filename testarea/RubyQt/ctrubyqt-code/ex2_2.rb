#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'

class MyWidget < Qt::Widget


  slots 'button_was_clicked()'


  def initialize(parent=nil)
    super(parent)
    @label = Qt::Label.new(self)
    @button = Qt::PushButton.new(self)
    @layout = Qt::VBoxLayout.new(self)


    @layout.addWidget(@label)
    @layout.addWidget(@button)


    @clicked_times = 0

    @label.setText("The button has been clicked " +
        @clicked_times.to_s + " times")
    @button.setText("My Button")


    connect(@button, SIGNAL('clicked()'), 
      self, SLOT('button_was_clicked()'))



  end


  def button_was_clicked
    @clicked_times += 1

    @label.setText("The button has been clicked " +
        @clicked_times.to_s + " times")
  end


end


a = Qt::Application.new(ARGV)
mw = MyWidget.new
a.setMainWidget(mw)
mw.show
a.exec

