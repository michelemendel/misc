require 'config'
require 'rubygems'
require_gem 'fxruby'
require 'fox12/colors'
require 'RMagick'

include Magick
include Fox


class Picture
    attr_reader :name
    attr_accessor :image, :data, :posX, :posY, :crossoverIdx, :nofMutations
    
    def initialize(name, posX, posY, app)
        @name = name
        @selected = false
        @posX = posX
        @posY = posY
        @app = app
        
        # Initialize configuration parameters
        @width = Config::ImgWidth
        @height = Config::ImgHeight
        @image = FXPNGImage.new(@app, nil, IMAGE_OWNED|IMAGE_KEEP|IMAGE_DITHER|IMAGE_SHMI|IMAGE_SHMP, @width, @height)
        @image = Image.new(@width, @height)
    end
    
    def selected?
        @selected
    end
    
    def selected=(sel)
        @selected = sel
    end
    
    def toggleSelected
        @selected = !@selected
    end
    
    def inBox?(x, y)
        if( x>=posX && x<=posX+@width && 
            y>=posY && y<=posY+@height)
            return true
        end
        return false
    end

    def diff(pic)
    
    end

    def initRandomData
        maxColor = 255
        @data = []
        (0..@width-1).each { |x|
            (0..@height-1).each { |y|
                @image.setPixel(x, y, FXRGB(rand(maxColor), rand(maxColor), rand(maxColor)))
                #~ z = (y * @width) + x
                #~ @data[z]  = FXRGB(rand(255), rand(255), rand(255))
            }
        }
    end
    
    def setPixel(x, y, fxRGBColor)
        @image.setPixel(x, y, fxRGBColor)
    end

    def getPixel(x, y)
        @image.getPixel(x, y)
    end
    
    def []=(p, fxRGBColor)
        @image.data[p] = fxRGBColor
    end
    
    def [](p)
        @image.data[p]
    end

    def each_index
        @image.data.data.each_index do |idx|
            yield idx
        end
    end
    
    def to_s
        puts "Pic name: #{@name}"
        puts "Image size: #{@image.data.size}"
    end
    
    # Loads an image file to data array.
    def loadFromFile(file)
        begin
            FXFileStream.open(file, FXStreamLoad) { |stream| @image.loadPixels(stream) }
            #~ @data = img.data.data
        rescue Fox::FXStreamNoReadError => error
            puts "File #{file} doesn't exists. Using random image."
            initRandomData
        end
    end

    # Saving data array to an image file.
    def saveToFile
        border = 4
        imgToSave = FXPNGImage.new(@app, nil, IMAGE_SHMI|IMAGE_SHMP, @width+border, @height+border)
        imgToSave.create
        #~ img = FXImage.new(@app, @image.data.data, IMAGE_OWNED|IMAGE_DITHER|IMAGE_SHMI|IMAGE_SHMP, @width, @height)
        @image.create
        
        dc = FXDCWindow.new(imgToSave)
        dc.foreground = FXColor::Black
        dc.fillRectangle(0, 0, @width+border, @height+border)
        dc.drawImage(@image, border/2, border/2)

        file = name + '.png'
        FXFileStream.open(file, FXStreamSave) { |stream| 
            imgToSave.restore #Restore image from offscreen pixmap
            imgToSave.savePixels(stream) 
        }
    end    
end


#
# Some simple tests
#

def getPixel
    pic = Picture.new("1",10,10, FXApp.new)
    pic.loadFromFile("2load.png")
    
    pic.setPixel(10, 0, FXRGB(255, 0, 0))
    puts pic.getPixel(10, 0)
    
    pic[30] = FXRGB(255, 0, 0)
    puts pic[30]
end

def misc
    pic = Picture.new("1",10,10, FXApp.new)
    #~ pic.loadFromFile("1load.png") #4294967295
    #~ pic.to_s
    #~ pic.data.each_index{|id|
        #~ printf("%04d:%b\n", id, pic.data[id])
    #~ }
    
end

def savePic
    pic = Picture.new("1",10,10, FXApp.new)
    pic.loadFromFile("2load.png")
    pic.to_s
    pic.saveToFile
end

def loadPic
    pic = Picture.new("1",10,10, FXApp.new)
    pic.to_s
    pic.loadFromFile("2load.png")
    #~ pic.loadFromFile("noFile.png")
end

def testingPixels
    c000 = FXRGB(0, 0, 0)
    c100 = FXRGB(1, 0, 0)
    c010 = FXRGB(0, 1, 0)
    c001 = FXRGB(0, 0, 1)
    cm00 = FXRGB(255, 0, 0)
    c0m0 = FXRGB(0, 255, 0)
    c00m = FXRGB(0, 0, 255)
    
    printf("%b\n",c000)
    puts
    printf("%b\n",c100)
    printf("%b\n",c010)
    printf("%b\n",c001)
    puts
    printf("%b\n",cm00)
    printf("%b\n",c0m0)
    printf("%b\n",c00m)
    puts
    
    
    #~ printf("%b\n",c100 | c010 | c001)
    #~ puts
    #~ puts (c000-c100)
    #~ puts (c000-c010)
    #~ puts (c000-c001)
end

if(__FILE__ == $0)
    #~ misc
    #~ loadPic
    #~ savePic
    #~ testingPixels
    getPixel
end

