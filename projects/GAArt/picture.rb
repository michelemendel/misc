require 'config'
require 'RMagick'

include Magick

class Picture
    attr_reader :name
    attr_accessor :image, :posX, :posY, :crossoverIdx, :nofMutations
    
    def initialize(name, posX, posY)
        @name = name
        @selected = false
        @posX = posX
        @posY = posY
        
        # Initialize configuration parameters
        @width = Config::ImgWidth
        @height = Config::ImgHeight
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

    def initRandomData
        (0..@image.columns).each { |col|
            (0..@image.rows).each { |row|
                @image.pixel_color(col, row, Pixel.new(rand(MaxRGB), rand(MaxRGB), rand(MaxRGB)))
            }
        }
    end
    
    def rgba(r, g, b, a=0)
        Pixel.new(r, g, b, a)
    end
    
    def setPixel(x, y, color)
        @image.pixel_color(x, y, color)
    end

    def getPixel(x, y)
        @image.pixel_color(x, y)
    end

    def getPixels
        @image.get_pixels(0, 0, @width, @height)
    end
    
    #~ def []=(p, fxRGBColor)
        #~ @image.data[p] = fxRGBColor
    #~ end
    
    #~ def [](p)
        #~ @image.data[p]
    #~ end

    #~ def each_index
        #~ @image.data.data.each_index do |idx|
            #~ yield idx
        #~ end
    #~ end
    
    def to_s
        puts "Pic name: #{@name}"
        puts "Image size (cols x rows): #{@image.columns} x #{@image.rows}"
    end
    
    # Loads an image file to data array.
    def load(file)
        begin
            @image = Image.read(file).first
        rescue  => error
            puts "File #{file} doesn't exists. Using random image."
            initRandomData
        end
    end

    # Saving data array to an image file.
    def save
        # Draw a frame.
        frame = Draw.new
        frame.stroke("black")
        frame.stroke_width(2)
        frame.fill_opacity(0)
        frame.rectangle(0, 0, @image.columns-1, @image.rows-1)
        frame.draw(@image)
        
        @image.write(name + '.png')
    end    
end


#
# Some simple tests
#

def showImageData
    pic = Picture.new("test_showImageData",10,10)
    pic.load("2load.png")
    pic.to_s
end

def loadSave1
    pic = Picture.new("test_LoadSave",10,10)
    pic.load("2load.png")
    pic.save
end

def loadSave2
    # Should create a random image.
    pic = Picture.new("test_LoadRandom",10,10)
    pic.load("NoImage")
    pic.save
end

def getSetPixel
    pic = Picture.new("test_GetSetPixel",10,10)
    pic.load("white.png")

    pxl = pic.getPixel(5, 5)
    puts pxl
    
    pic.setPixel(10, 0, pic.rgba(255, 0, 0))
    puts pic.getPixel(10, 0)

    pic.setPixel(10, 10, "blue")
    puts pic.getPixel(10, 0)
    
    pic.save
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
    showImageData
    getSetPixel
    loadSave1
    loadSave2
    #~ testingPixels
end

