#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
require 'Qt'

class VC < Qt::Widget
  signals 'mySignal()'
  slots 'myPublicSlot()','myProtectedSlot()','myPrivateSlot()'

  def myPublicSlot
    puts "myPublicSlot was called"
  end

protected
  def myProtectedSlot
    puts "myProtectedSlot was called"
  end

private
  def myPrivateSlot
    puts "myPrivateSlot was called"
  end

end

class VC_2 < VC
end

app = Qt::Application.new(ARGV)
$vc = VC.new
$vc2 = VC_2.new
$b = Qt::PushButton.new(nil)

# Valid
Qt::Object::connect($b, SIGNAL('clicked()'), $vc, SLOT('myPublicSlot()'))
Qt::Object::connect($b, SIGNAL('clicked()'), $vc, SLOT('myProtectedSlot()'))
Qt::Object::connect($b, SIGNAL('clicked()'), $vc, SLOT('myPrivateSlot()'))

# Valid
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myPublicSlot()'))
# Invalid
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myProtectedSlot()'))
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myPrivateSlot()'))

# Valid
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myPublicSlot()'))
# Invalid
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myProtectedSlot()'))
Qt::Object::connect($b, SIGNAL('clicked()'), $vc2, SLOT('myPrivateSlot()'))
