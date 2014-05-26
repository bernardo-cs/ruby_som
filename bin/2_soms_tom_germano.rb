#require 'pry'
require_relative '../lib/som.rb'
#require 'benchmark'

## Initialize the Output Space randomly
#  A) Initialize the SOM with 100 random neurons,
#     add 1000 random input patterns
som = SOM::SOM.new output_space_size: 15,
                   epochs: 200
## Randomly fill the output space
(225).times{ som.output_space.add(SOM::Neuron.new(3){ rand 0..255 }) }

## Generate 1500 random input patterns
som.input_patterns = 1500.times.inject([]){ |arr| arr << Array.new(3){ rand(0..255) }; arr  }

som.exec! do |som_state|
  puts "radius: #{som_state.radius}\t\t learning_rate: #{som_state.learning_rate}"
end
som.output_space.print_matrix(5,5, file_name: '2_som.bmp')
som.create_umatrix('2_som_umatrix.bmp')

`say Finished training everything, Sir`
