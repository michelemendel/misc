class FiniteStateMathing
  attr_accessor :state
  
  def initialize( current_state=nil )
    @state = current_state
  end
  
  # Add a new state to the class, associating it with a transition handler (passed as block)
  def self.handle_state( state, &handler )
    if handler
      name = "__handlestate__#{state.object_id}"
      state_handler_name[ state ] = name
      define_method( name, &handler )
    end
  end
  
  def show_state_handler_name
    p self.class
    p self.class.state_handler_name
  end

  # Passes the +trigger+ value to the handler for the current
  # state, and uses the return value of that handler as the new
  # state.
  #
  # Returns +nil+ if no handler exists for the current state;
  # otherwise returns the new state returned by the handler.
  def transition( trigger )
    raise "Must set the current/start state first." unless @state

    initial_state = @state if $DEBUG

    handler_name = self.class.state_handler_name[ @state ]
    unless handler_name
      puts "No handler for state #@state" if $DEBUG
      return nil
    end

    # Invoke the handler for this state, passing in the trigger
    # and use the return value as the new state
    @state = send( handler_name, trigger )
    puts "#{self}.transition(#{trigger}) :: #{initial_state} -> #@state" if $DEBUG
    @state
  end

  private
    def self.state_handler_name
      @state_handler_name ||= {}
    end
end

class ElevatorState < FiniteStateMathing
   def sound_alarm
     puts "***BUZZ!***"
   end

   handle_state( :doors_closed ) do |command|
     @interruptions = 0
     case command
       when :open_doors then :opening_doors
       else :doors_closed
     end
   end

   handle_state( :opening_doors ) do |command|
     case command
       when :done_opening then :doors_opened
       when :close_doors then :closing_doors
       else :opening_doors
     end
   end

   handle_state( :closing_doors ) do |command|
     case command
       when :done_closing then :doors_closed
       when :hit_something, :open_doors
         if ( @interruptions += 1) > 4
           sound_alarm
           :closing_doors
         else
           :opening_doors
         end
       else :closing_doors
     end
   end

   handle_state( :doors_opened ) do |command|
     case command
       when :close_doors, :open_timeout
         :closing_doors
       else :doors_opened
     end
   end
end

 valid_commands_per_state = {
   :doors_closed =>  [ :open_doors, :close_doors ],
   :opening_doors => [ :open_doors, :close_doors, :done_opening ],
   :doors_opened =>  [ :open_doors, :close_doors, :open_timeout ],
   :closing_doors => [ :open_doors, :close_doors, :done_closing, :hit_something ]
 }
 door_controller = ElevatorState.new( :doors_closed )

 11.times{
   valid_commands = valid_commands_per_state[ door_controller.state ]
   command = valid_commands[ rand( valid_commands.length ) ]
   print "#{door_controller.state}\n+ #{command} => "
   door_controller.transition( command )
 }
 print "#{door_controller.state}\n\n"
 
 
 door_controller.show_state_handler_name
