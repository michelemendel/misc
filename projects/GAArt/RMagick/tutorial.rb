require 'RMagick'
require 'rubygems'
require_gem 'fxruby'
require 'fox12/colors'

include Magick
include Fox

def write(fn, disp=false)
    if(fn.class == Magick::Image)
        tmpFn = "tmpFile.png"
        fn.write(tmpFn)
        file = tmpFn
    else
        file = fn
    end
    
    if disp
        app = "C:/Program Files/mozilla.org/Mozilla/mozilla.exe "
        appfile = app+"file://"+Dir.getwd+"/"+file
        puts appfile
        exec(appfile)
    end
end


def a
    cat = ImageList.new("Cheetah.jpg")
    smallcat = cat.minify
    fn = "SmallCheetah.png"
    smallcat.write(fn)
end

def b
    f = Image.new(100,100){ 
        self.background_color = "red"
    }
    write(f)
end

def c
    anim = ImageList.new("Button_1.gif", "Button_2.gif", "Button_3.gif")
    anim.write("animated.gif")
end

def d
    imgList = ImageList.new("1load.png")
    puts imgList.class
    puts imgList[0].class
    puts "#{imgList.columns} x #{imgList.rows}"
    
    img = Image.read("1load.png").first
    puts img.class
    puts "#{img.columns} x #{img.rows}"
    
    ar = img.get_pixels(0,0,img.columns,img.rows)
    ar.each do |it|
        puts it
    end
end

def convolve
    emb = [ -0.2,-0.2, 0, 
            -0.2,   1, 0, 
               0,   0, 0 ]
                  
    sharpen = [ 0, -2, 0.1, 
               -2, 5,  -2, 
                0, -2,   0 ]
               
    img = ImageList.new("Cheetah.jpg")
    convImg = img.convolve(3, sharpen)
    convImg.write("Cheeta-convolved.jpg")
end

def diff(f1, f2)
    img1 = ImageList.new(f1)
    img2 = ImageList.new(f2)
    d = img1.difference(img2)
    #~ p d
    printf("%-17.5f %-19.5f %-.5f\n", d[0], d[1], d[2])
end

def diffTest
    printf("%s %s %s\n", "MeanErrorPerPixel", "NormalizedMeanError", "NormalizedMaximumError")
    diff("d1.bmp", "d1.bmp")
    diff("d1.bmp", "d2.bmp")
    diff("d1.bmp", "d3.bmp")
    diff("d1.bmp", "d4.bmp")
    diff("d1.bmp", "d5.bmp")
    diff("d1.bmp", "d6.bmp")
    diff("d2.bmp", "d3.bmp")
end

#~ img = Image.new(50,50)
#~ puts img.class

def getApp()
    FXApp.new
end
@imgWidth, @imgHeight = 100, 100

img = Image.read("1load.png").first
pixels = img.get_pixels(0,0,img.columns,img.rows)
pixels = img.export_pixels(0,0,img.columns,img.rows,"RGB")
#~ puts pixels
#~ puts img.methods.sort


fxColor = []
#~ pixels.each do |pxl|
    #~ puts "#{pxl.red},#{pxl.green},#{pxl.blue}"
    #~ puts "#{pxl}"
    #~ fxColor << FXRGB(pxl.red, pxl.green, pxl.blue)
#~ end

#~ fxImg = FXImage.new(getApp(), fxColor, IMAGE_OWNED|IMAGE_DITHER|IMAGE_SHMI|IMAGE_SHMP, @imgWidth, @imgHeight)

