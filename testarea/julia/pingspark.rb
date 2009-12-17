require 'zlib'
  
  def build_png_chunk(type,data)
      to_check = type + data
      return [data.length].pack("N") + to_check + [Zlib.crc32(to_check)].pack("N")
  end
  
  def build_png(image_rows)
      header = [137, 80, 78, 71, 13, 10, 26, 10].pack("C*")
      raw_data = image_rows.map { |row| [0] + row }.flatten.pack("C*")
      ihdr_data = [image_rows.first.length,image_rows.length,
      8,2,0,0,0].pack("NNCCCCC")
      ihdr = build_png_chunk("IHDR", ihdr_data)
      trns = build_png_chunk("tRNS", ([ 0xFF ]*6).pack("C6"))
      idat = build_png_chunk("IDAT", Zlib::Deflate.deflate(raw_data))
      iend = build_png_chunk("IEND", "")
      
      return header + ihdr + trns + idat + iend
  end
  
  def bumpspark( results )
      white, red, grey = [0xFF,0xFF,0xFF], [0,0,0xFF], [0x99,0x99,0x99]
      rows = results.inject([]) do |ary, r|
          ary << [white]*15 << [white]*15
          ary.last[r/9,4] = [(r > 50 and red or grey)]*4
          ary
      end.transpose.reverse
      return build_png(rows)
  end
  
File.open( 'sparkline.png', 'wb' ) do |png|
    png.print(bumpspark((0..200).map{ rand 100 }))
end
