

require 'ramaze'

class MainController < Ramaze::Controller
    
    engine :Markaby
    helper :markaby
    
    def index
        "Internal template"
    end
end
