require 'pry'
require_relative '../lib/som.rb'
require 'benchmark'


## Initialize the Output Space randomly
#  A) Initialize the SOM with 100 random neurons,
#     add 1000 random input patterns
som = SOM::SOM.new output_space_size: 25,
                   radius: 50,
                   epochs: 200
(625).times{ som.output_space.add(SOM::Neuron.new(3){ rand 0..255 }) }
som.output_space.print_matrix(5,5)
som.input_patterns = 1500.times.inject([]){ |arr| arr << Array.new(3){ rand(0..255) }; arr  }

#  B) Get the best matching unit,
#     for the first input_pattern
#     after the first epoch
som.exec!
puts som.bmus[som.input_patterns.first]
#  print the new som
begin
  som.output_space.print_matrix(5,5)
rescue
  puts "cannot print non images stuff bears nha"
end

