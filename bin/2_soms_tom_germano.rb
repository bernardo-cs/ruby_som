require 'pry'
require_relative '../lib/som.rb'
require 'benchmark'


## Initialize the Output Space randomly
#  A) Initialize the SOM with 100 random neurons,
#     add 1000 random input patterns
som = SOM::SOM.new output_space_size: 25,
                   radius: 13,
                   epochs: 200
## Randomly fill the output space
(625).times{ som.output_space.add(SOM::Neuron.new(3){ rand 0..255 }) }

## Generate 1500 random input patterns
som.input_patterns = 1500.times.inject([]){ |arr| arr << Array.new(3){ rand(0..255) }; arr  }

som.exec!
som.output_space.print_matrix(5,5, file_name: '1_som.bmp')
som.create_umatrix('1_som_umatrix.bmp')

`say Finished training everything, Sir`
