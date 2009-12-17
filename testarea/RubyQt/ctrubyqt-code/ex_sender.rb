#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'

class SignalObject < Qt::Object
  signals 'mySignal()'

  def initialize(parent=nil)
    super(parent)
  end

  def trigger
    emit mySignal()
  end

end

class SlotObject < Qt::Object
  slots 'mySlot()'

  def initialize(parent=nil)
    super(parent)
  end

  def mySlot
    puts "Slot called by #{sender.class}"
  end
end

sig  = SignalObject.new
slot = SlotObject.new

Qt::Object::connect(sig, SIGNAL('mySignal()'),
  slot, SLOT('mySlot()') )
