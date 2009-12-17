require 'pp'
require 'rubygems'
require_gem 'fxruby'
require 'fox12/colors'
require 'picture'
require 'config'
require 'ga'
require 'RMagick'

include Magick
include GA
include Fox

class ImageWindow < FXMainWindow

    def initialize(app)
        super(app, "GA Art", nil, nil, DECOR_ALL, 0, 0, Config::CanvasWidth, Config::CanvasHeight)
        
        @app = app
        
        # Initialize configuration parameters
        @imgWidth = Config::ImgWidth
        @imgHeight = Config::ImgHeight
        @cellSpace = Config::CellSpace
        @curSelections = []
        initPics
        loadPicturesFromFiles
        initWindow
        
        # Font
        @font = FXFont.new(getApp(), "Arial", 8, FONTWEIGHT_NORMAL)
        @font.create

        # Result image to paint pictures on.
        @canvas = FXPNGImage.new(getApp(), nil, IMAGE_SHMI|IMAGE_SHMP, Config::CanvasWidth, Config::CanvasHeight)
        @canvas.create
        #~ @canvas = Image.new(Config::CanvasWidth, Config::CanvasHeight)
    end


    def repaint(sender, sel, event)
        repaintCanvas(event)
        repaintFrame(event)
    end
    
    def repaintCanvas(event)
        if event.synthetic
            dc = FXDCWindow.new(@canvas)
            
            # Erase the picture, color comes from well
            dc.foreground = @backwell.rgba
            dc.fillRectangle(0, 0, @canvas.width, @canvas.height)
            
            @pics.each{ |pic| drawImage(dc, pic) }
            
            dc.end
        end
    end

    # Repaint the screen
    def repaintFrame(event)
        sdc = FXDCWindow.new(@frame, event)
        sdc.foreground = @backwell.rgba
        sdc.fillRectangle(0, 0, @frame.width, @frame.height)
        
        sdc.drawImage(@canvas, 0, 0)
        
        sdc.end
    end
    
    def drawImage(dc, pic)
        img = FXImage.new(getApp(), pic.image, IMAGE_OWNED|IMAGE_DITHER|IMAGE_SHMI|IMAGE_SHMP, @imgWidth, @imgHeight)
        img.create
        
        # Draw image
        dc.drawImage(img, pic.posX, pic.posY)
        
        # Draw border
        dc.foreground = pic.selected? ? FXColor::White : FXColor::Black
        dc.drawRectangle(pic.posX, pic.posY, @imgWidth, @imgHeight)    
        
        # Draw text
        dc.font = @font
        dc.foreground = @textwell.rgba
        text = sprintf("%s (%d / %d)", pic.name, pic.crossoverIdx, pic.nofMutations)
        dc.drawText(pic.posX, pic.posY+@imgHeight+11, text)
    end

    def placeFirst(pic)
        start = @pics.index(pic) - 1
        
        nextPicX, nextPicY = pic.posX, pic.posY
        pic.posX, pic.posY = @pics[0].posX, @pics[0].posY
        
        # Remove from array
        @pics.delete(pic){"not found"}
        
        # Shift all elements before pic to the right
        start.downto(0){|idx|
            @pics[idx].posX, nextPicX = nextPicX, @pics[idx].posX
            @pics[idx].posY, nextPicY = nextPicY, @pics[idx].posY
        }
        
        # Add to beginning of array
        @pics.unshift(pic) 
    end

    def printPicsArray
        @pics.each{ |pic| 
            print "#{pic.name} (#{pic.posX},#{pic.posY})\n" 
        }
        puts
    end

    
    # Color well got changed
    def selectColor(sender, sel, ptr)
        @frame.update
    end

    def selectPic(sender, sel, event)
        x = event.last_x
        y = event.last_y
        
        @pics.each{ |pic|
            if(pic.inBox?(x,y) && !@curSelections.include?(pic))
                @curSelections.unshift(pic)
                if(@curSelections.size == 2)
                    #~ crossoverAndMutate!(@curSelections)
                    @curSelections.each{ |pic|
                        placeFirst(pic)
                        pic.selected = false
                    }
                    @curSelections.clear
                    break
                else
                    pic.selected = true
                    break
                end
            end
        }
        
        @frame.update
    end
    
    def saveCanvas(sender, sel, ptr)
        saveDialog = FXFileDialog.new(self, "Save as PNG")
        if saveDialog.execute != 0
            fn = saveDialog.filename.concat('.png')
            @app.beginWaitCursor do
                FXFileStream.open(fn, FXStreamSave) do |outfile|
                    @canvas.restore #Restore image from offscreen pixmap
                    @canvas.savePixels(outfile)
                end
            end
        end
    end

    def savePicture(sender, sel, ptr)
        @app.beginWaitCursor do
            @pics[0].saveToFile
        end
    end
    
    #
    # Initializing methods
    #
    
    def initPics
        nofCols = 5
        counterX = 0
        counterY = 0
        posY = @cellSpace
        
        @pics = Array.new(Config::NofPics){ |idx|
            if(counterX == nofCols)
                counterX = 0
                counterY += 1
                posY = @cellSpace + counterY*(@cellSpace+@imgHeight)
                
            end
            posX = @cellSpace + counterX*(@cellSpace+@imgWidth)
            counterX += 1
            Picture.new((idx+1).to_s, posX, posY)
        }
    end
    
    def loadPicturesFromFiles
        @pics.each{|pic| 
            fn = pic.name+'load.png'
            pic.load(fn)
        }
    end
    
    def initWindow
        # Create a color dialog for later use
        colordlg = FXColorDialog.new(self, "Color Dialog")
        
        contents = FXHorizontalFrame.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y, 0, 0, 0, 0, 0, 0, 0, 0)
      
        # LEFT pane to contain the canvas
        canvasFrame = FXVerticalFrame.new(contents, 
            FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
            0, 0, 0, 0, 0, 0, 0, 0)
            
        # Drawing canvas
        @frame = FXCanvas.new(canvasFrame, nil, 0, 
            FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_RIGHT)
        @frame.connect(SEL_PAINT, method(:repaint))
        @frame.connect(SEL_LEFTBUTTONPRESS, method(:selectPic))
    
    
        # RIGHT pane for the buttons
        buttonFrame = FXVerticalFrame.new(contents, 
            (FRAME_SUNKEN|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT), 0, 0, 0, 0, 10, 10, 10, 10)
    
        FXHorizontalSeparator.new(buttonFrame, SEPARATOR_RIDGE|LAYOUT_FILL_X)
    
        FXLabel.new(buttonFrame, "&Background Color", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X)
        @backwell = FXColorWell.new(buttonFrame, FXRGB(50, 50, 50), nil, 0, 
            (LAYOUT_CENTER_X|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT), 0, 0, 100, 30)
        @backwell.connect(SEL_COMMAND, method(:selectColor))
        
        FXLabel.new(buttonFrame, "&Text Color", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X)
        @textwell = FXColorWell.new(buttonFrame, FXColor::White, nil, 0, 
            (LAYOUT_CENTER_X|LAYOUT_TOP|LAYOUT_LEFT|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT), 0, 0, 100, 30)
        @textwell.connect(SEL_COMMAND, method(:selectColor))
        
        # Save Button - the whole canvas
        saveBtnCanvas = FXButton.new(buttonFrame, "Save Canvas...", nil, nil, 0, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0, 0, 0, 0, 10, 10, 5, 5)
        saveBtnCanvas.connect(SEL_COMMAND, method(:saveCanvas))
        
        # Save Button - the first picture
        saveBtnFirstPic = FXButton.new(buttonFrame, "Save First Pic...", nil, nil, 0, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0, 0, 0, 0, 10, 10, 5, 5)
        saveBtnFirstPic.connect(SEL_COMMAND, method(:savePicture))
        
        # Exit button
        FXButton.new(buttonFrame, "E&xit\tQuit ImageApp", nil, getApp(), FXApp::ID_QUIT, 
            (FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT), 0, 0, 0, 0, 10, 10, 5, 5)


        FXToolTip.new(getApp())
    end
    
    # Create and initialize
    def create
        super
        show(PLACEMENT_SCREEN)
    end
end

def runApp
  app = FXApp.new("Image", "FoxTest")
  ImageWindow.new(app)
  app.create
  app.run
end

runApp if __FILE__ == $0

