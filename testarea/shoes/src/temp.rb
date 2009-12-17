
#require 'util'
require 'telenor_logo'




Shoes.app :width => 160, :height => 160 do
  stack do
    displace 20,20
    telenor_logo.show
  end
end

