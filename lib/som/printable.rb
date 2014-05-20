require 'imageruby'
include ImageRuby

## Prints Matrixes into images
#  each_row and @export_path, must be available
module Printable

  WHITE = 255
  BLACK = 0

  def to_image(*args)
   case args.size 
     when 1
       imagify(args.first,args.first)
     when 2
       imagify(args.first,args.last)
     else 
       imagify(5,5)
   end 
  end

  def normalize_colour avg, min, max
    ((1-((avg.to_f-min)/(max-min)))*255).round(0)
  end

  def imagify (pixel_width, pixel_height)
   Image.new(pixel_width, pixel_height, Color.from_rgb(*self.map{ |f| Integer( f.round 0 )})) if size == 3
   #print_matrix(pixel_width, pixel_height) if self.first.size == 3
  end

  def print_matrix (pixel_width, pixel_height)
    x,y = 0,0
    image = Image.new(pixel_width * first_row.size, pixel_height * size)
    each_row do |row|
      row.each do |n|
        #print white if n is nil
        n = Neuron.new([255,255,255]) if n.nil?
        image[x..x+(pixel_width-1), y..y+(pixel_height-1)] = n.to_image
        x += pixel_width
      end
      x = 0
      y += pixel_height
    end
    image.save(File.join(export_path, "som.bmp"), :bmp)
  end
end
