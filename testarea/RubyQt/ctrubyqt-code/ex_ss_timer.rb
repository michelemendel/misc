#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---
class MyTimer < Qt::Widget
  signals 'tripped_times_signal(int)'
  slots 'timer_tripped_slot()'

  def initialize(parent)
    super(parent)

    @timer = Qt::Timer.new(self)
    @label = Qt::Label.new(self)
    @tripped_times = 0

    connect(@timer, SIGNAL('timeout()'), 
      self, SLOT('timer_tripped_slot()'))
    # Make the timer trip every second (1000 milliseconds)
    @timer.start(1000)
  end

  def timer_tripped_slot()
    @tripped_times += 1;
    @label.setText("The timer has tripped " + 
      @tripped_times.to_s + " times")

    emit tripped_times_signal(@tripped_times)
  end

end
