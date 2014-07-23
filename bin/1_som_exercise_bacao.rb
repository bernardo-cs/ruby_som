require 'pry'
require_relative '../lib/som.rb'
require_relative "../lib/som/matrix.rb"

### SOM Exercise data:
# Input Patterns:
#  [1,1,0,0]
#  [0,0,1,1]
#  [1,0,0,0]
#  [0,0,1,1]
#
# Neurons:
# N1 [0.2,0.6,0.5,0.9]
# N2 [0.8,0.4,0.7,0.3]
#
# Radius: r=0
# Learning Rate alpha = 0.6

## Initialize the problem
som = SOM::SOM.new learning_rate: 0.6, force_radius: 1, epochs: 1
som.input_patterns = SOM::Matrix.new([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]])
[ SOM::Neuron.new( [0.2,0.6,0.5,0.9] ),
  SOM::Neuron.new( [0.8,0.4,0.7,0.3] )].each{ |n| som.output_space.add n }

som.exec! do |som_state, i|
  puts "iteration: #{i} radius: #{som_state.radius}, learning_rate: #{som_state.learning_rate}"
end
puts som.to_s
