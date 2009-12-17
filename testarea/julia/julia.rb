  require "complex"

  c = Complex(-0.75, 0.136)          # the Julia set parameter
  iters = 50                         # max iterations
  w, h = 400, 300                    # bitmap extents
  rx, ry = -1.0 .. 1.0, -1.0 .. 1.0  # view area

  sx = (rx.last - rx.first).abs / w  # x-scale
  sy = (ry.last - ry.first).abs / h  # y-scale

  colmap = Array.new(256, "\000"*3)  # color map

    # initialize colormap
    (1..255).each {|i| 
        colmap[i] = [10+i*10, 0, rand*100].pack("CCC") 
    }

  # write PNM header
  print "P6\n#{w} #{h}\n255\n"

  # do the real stuff
  for j in 0...h
    for i in 0...w
      n, zn = 0, Complex(sx*i+rx.first, sy*j+ry.first)
      while n <= iters
        # sequence runs away to infinity
        break if (zn-c).abs > 2

        # calculate next iteration
        zn = zn**2 + c; n += 1
      end

      # draw/print pixel
      print colmap[n]
    end
  end
