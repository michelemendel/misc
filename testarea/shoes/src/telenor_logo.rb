

Shoes.app :width => 160, :height => 160 do
  stack do
    displace 20,20
    telenor_logo.show
  end
end

class Shoes::TelenorLogo < Shoes::Widget
  def show
      @logo = image 'telenor_logo.gif'
      animate(24) do
        @logo.rotate(7)
      end
  end
end


