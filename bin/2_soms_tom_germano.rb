require 'pry'
require_relative '../lib/som.rb'
require 'benchmark'


## Initialize the Output Space randomly
#  A) Initialize the SOM with 100 random neurons,
#     add 1000 random input patterns
som = SOM::SOM.new output_space_size: 10,
                   radius: 10,
                   epochs: 100
100.times{ som.output_space.add(SOM::Neuron.new(3000){ rand 0..1 }) }
#som.output_space.print_matrix(5,5)
som.input_patterns = 500.times.inject([]){ |arr| arr << Array.new(3000){ rand(0..1) }; arr  }

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

