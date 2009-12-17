require 'generated/svg/svg_writer.rb'

doc = Svg_doc.new 
root = doc.root

#d = DocType.new '[<!ENTITY foo "bar">]'
#ent = EntityDecl.new('<!ENTITY foo "bar">') #, {'foo'=>'bar'}
#d.add ent
#prolog = Declaration.new('1.0')
#doc.add d #,prolog
#doc.add prolog

root.viewBox = '0 0 400 300'

70.times do |integer|
  f = integer.to_f
  e = Ellipse.new
  e.rx = f;e.ry = 20+(f/4) #*1.2
  e.cx = e.cy = f*3 #(f/2) #5*(f/(f+1))
  e.fill = :hotpink
  e.opacity = 0.1
  
  ani = Animate.new
  ani.attributeName = 'ry'
  ani.fill = 'freeze'
  ani.dur = 1
  ani.svg_begin = f / 16
  ani.calcMode = 'spline'
  val01 = e.ry.to_s
  val02 = (e.ry*(f/30)).to_s
  ani.values = val01+';'+val02+';'+val01
  ani.keySplines = '0.5 0 0.5 1'
  ani.keyTimes = '1;0.5;1'
  ani.repeatCount = :indefinite
  
  bg = Rect.new
  bg.width=40000
  bg.height=30000
  bg.fill = :black
  #root.add bg
  
  
  root.add_element(e).add_element(ani)
  
end

doc << Document::DECLARATION

def write_to_dir string
  open('generated/svg/'+'sample02.svg', 'w') do |file|
    file.write string
  end
end

write_to_dir doc