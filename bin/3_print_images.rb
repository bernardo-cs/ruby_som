### Script to print a 250*250 matrix 
#   of squares of 5*5 colours

require "imageruby"

include ImageRuby

x = 0
y = 0
image = Image.new(50 * 5, 50 * 5)
50.times do 
  50.times do 
    image[x..x+4,y..y+4] = Image.new(5,5,Color.from_rgb(*[rand(0..255), rand(0..255), rand(0..255)]))
    x += 5
    puts "printing to [#{x},#{y}]"
  end
  x = 0
  y += 5
end

image.save("colors.bmp", :bmp)
