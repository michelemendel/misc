class StateContext
    attr_accessor :state_exclaim, :state_stars

    def initialize
        @state_exclaim = StateExclaim.new
        @state_stars = StateStars.new
        
        setCurrentState(@state_stars) # start with stars
    end
   
    def setCurrentState(current_state)
        @current_state = current_state
    end

    def showName(name)
        @current_state.showName(self, name)
    end
end

#~ one of two Concrete States
class StateExclaim
    def showName(state_context, name) 
        puts(name.gsub(' ','!'))
        # show exclaim only once, switch back to stars
        state_context.setCurrentState(state_context.state_stars)
    end
end

#~ two of two Concrete States
class StateStars
    def initialize
        @star_count = 0
    end
    
    def showName(state_context, name)
        puts(name.gsub(' ','*'))
        # show stars twice, switch to exclamation point
        @star_count += 1
        if(@star_count > 1)
            @star_count = 0
            state_context.setCurrentState(state_context.state_exclaim)
        end
    end
end

class TestState
    def go
        @state_context = StateContext.new
        @state_context.showName("Sponge Bob Squarepants - Nautical Nonsense and Sponge Buddies")
        @state_context.showName("Jay and Silent Bob Strike Back")  
        @state_context.showName("Buffy The Vampire Slayer Season 2")
        @state_context.showName("The Sopranos Season 2")
        @state_context.showName("The Sopranos Season 3")
        @state_context.showName("The Sopranos Season 4")
        @state_context.showName("The Sopranos Season 5")
        @state_context.showName("Buffy The Vampire Slayer Season 3")
        @state_context.showName("Buffy The Vampire Slayer Season 4")
        @state_context.showName("Buffy The Vampire Slayer Season 5")
    end
end

TestState.new.go