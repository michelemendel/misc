

def draw_thing(a)
  a.app do

    #    stack :width=>106, :height=>110 do
    #      border black
    @logo = image 'telenor_logo.gif'
    #    end

    transform(:corner)
    animate(5) do
      translate(5,0)
      #      @logo.translate(5,0)
      @logo.rotate(0)
    end
  end
end