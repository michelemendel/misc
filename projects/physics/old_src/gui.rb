require 'pp'
require 'rubygems'
#require_gem 'fxruby'
require 'fox16/colors'
require 'config'


include Fox

class PhysicsGUI < FXMainWindow

    # How often our timer will fire (in milliseconds)
    TIMER_INTERVAL = 1 # In ms.

    def initialize(app, model)
        super(app, "Spring Physics", nil, nil, DECOR_ALL, 0, 0, Config::CanvasWidth, Config::CanvasHeight)
        @app = app
        @model = model
        @t = 0
        @dt = 0.05
        
        initWindow    
    end

    # Animate when a timer message is received. 
    # Controlled by variable @animating.
    def onTimeout(sender, sel, ptr)
        @model.integrate(@t, @dt)
        @t += @dt

        @canvas.update
        @timer = getApp().addTimeout(TIMER_INTERVAL, method(:onTimeout))
    end
    
    # Color well got changed
    def selectColor(sender, sel, event)
        @canvas.update
    end
    
    #Called by @canvas.update
    def repaint(sender, sel, event)
        sdc = FXDCWindow.new(@canvas, event)
        sdc.foreground = @backwell.rgba
        sdc.fillRectangle(0, 0, @canvas.width, @canvas.height)
        sdc.foreground = FXColor::Black #Default
        @model.render(sdc)
        sdc.end
    end
    


    #
    # Initializing methods
    #
    
    def initWindow
        # Create a color dialog for later use
        colordlg = FXColorDialog.new(self, "Color Dialog")
        
        contents = FXHorizontalFrame.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 0,0,0,0,0,0,0,0)
      
        # LEFT pane to contain the canvas
        canvasFrame = FXVerticalFrame.new(contents, 
            FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT, 0,0,0,0,0,0,0,0,0,0)
        canvasFrame.connect(SEL_UPDATE) { |sender, sel, event|
            @model.setMaxDimensions(@canvas.width, @canvas.height)
        }
        
        # RIGHT pane for the buttons
        buttonFrame = FXVerticalFrame.new(contents, 
            (FRAME_GROOVE|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT), 0,0,0,0,10,10,0,0,2,2)


        # Drawing canvas
        @canvas = FXCanvas.new(canvasFrame, nil, 0, 
            FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_RIGHT)
        @canvas.connect(SEL_PAINT, method(:repaint))
        @canvas.connect(SEL_LEFTBUTTONPRESS) { |sender, sel, event|
            @model.leftButtonPressed(event.last_x, event.last_y)
            @canvas.update
        }
        @canvas.connect(SEL_LEFTBUTTONRELEASE) { |sender, sel, event|
            @model.leftButtonReleased(event.last_x, event.last_y)
            @canvas.update
        }
        @canvas.connect(SEL_MOTION) { |sender, sel, event|
            @model.mouseMove(event.last_x, event.last_y)
            @canvas.update
        }
    
        FXLabel.new(buttonFrame, "&Background Color", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X, 0,0,0,0,0,0,10,0)
        @backwell = FXColorWell.new(buttonFrame, FXRGB(255, 255, 255), nil, 0, 
            (LAYOUT_CENTER_X|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT), 0,0,100,30)
        @backwell.connect(SEL_COMMAND, method(:selectColor))
        
        FXLabel.new(buttonFrame, "&Text Color", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X, 0,0,0,0,0,0,10,0)
        @textwell = FXColorWell.new(buttonFrame, FXColor::White, nil, 0, 
            (LAYOUT_CENTER_X|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT), 0,0,100,30)
        @textwell.connect(SEL_COMMAND, method(:selectColor))
        
        # Animate Button
        animateBtn = FXButton.new(buttonFrame, "&Animate", nil, nil, 0, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0,0,0,0,10,10,5,5)
        animateBtn.connect(SEL_COMMAND) {
            @animating = true
            @timer = getApp().addTimeout(TIMER_INTERVAL, method(:onTimeout))
        }
        animateBtn.connect(SEL_UPDATE) { |sender, sel, ptr|
            @animating ? sender.disable : sender.enable
        }

        # Stop animation
        stopBtn = FXButton.new(buttonFrame, "&Stop Animation", nil, nil, 0, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0,0,0,0,10,10,5,5)
        stopBtn.connect(SEL_COMMAND) {
            @animating = false
            if @timer
                getApp().removeTimeout(@timer)
                @timer = nil
            end
        }
        stopBtn.connect(SEL_UPDATE) { |sender, sel, ptr|
            @animating ? sender.enable : sender.disable
        }
        
        # Exit button
        FXButton.new(buttonFrame, "E&xit\tQuit ImageApp", nil, getApp(), FXApp::ID_QUIT, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0,0,0,0,10,10,5,5)


        FXToolTip.new(getApp())

        # Font
        @font = FXFont.new(getApp(), "Arial", 8, FONTWEIGHT_NORMAL)
        @font.create
    end
    
    # Create and initialize
    def create
        super
        show(PLACEMENT_SCREEN)
    end
end

module PhysicsMain
    def runApp(model)
        app = FXApp.new("Physics", "MM")
        PhysicsGUI.new(app, model)
        app.create
        app.run
    end
end

