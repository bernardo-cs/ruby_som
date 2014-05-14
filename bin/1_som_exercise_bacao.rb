require 'pry'
require_relative '../lib/som.rb'

som = SOM::SOM.new 

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
som = SOM::SOM.new learning_rate: 0.6, radius: 0
som.input_patterns = Matrix.new([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]])
[ SOM::Neuron.new( [0.2,0.6,0.5,0.9] ),
  SOM::Neuron.new( [0.8,0.4,0.7,0.3] )].each{ |neuron| som.output_space.add( neuron ) }

## Run one Epoch
som.input_patterns.each do |input_pattern|
  puts "\n"
  puts "-- Input Pattern       #{input_pattern}"
  wn = som.output_space.find_winning_neuron( input_pattern )
  puts "   Winning Neuron: #{wn}"
  puts "   Updated Neuron: #{wn.learn(input_pattern, som.learning_rate)}"
  puts "   Distance:       #{wn.distance(input_pattern)}"
  position = som.output_space.find_neuron_position(wn)
  # Update neurons inside the radius
  som.output_space.get_neurons_in_radius(position, som.radius).each do |neuron|
    updated_neuron = neuron.learn(input_pattern, som.learning_rate)
    som.output_space.update_neuron_at_position(updated_neuron, position)
  end
end
puts som.to_s

## Initialize the problem
som = SOM::SOM.new learning_rate: 0.6, radius: 0
som.input_patterns = Matrix.new([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]])
[ SOM::Neuron.new( [0.2,0.6,0.5,0.9] ),
  SOM::Neuron.new( [0.8,0.4,0.7,0.3] )].each{ |neuron| som.output_space.add( neuron ) }
som.exec!
puts som.to_s

