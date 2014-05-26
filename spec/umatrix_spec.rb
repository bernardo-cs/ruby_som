#require_relative '../lib/som'
#include SOM

describe UMatrix do
  
  describe '#create_grid' do
    it "calculates the average distance of a bmu and all his inputut patterns" do
      bmus_list = { Neuron.new([1,1]) => [[0,0],[1,1],[0,0]],
                    Neuron.new([0,0]) => [[0,0],[0,0],[0,0]],
                    Neuron.new([1,0]) => [[1,1],[0,0],[0,0]],
                    Neuron.new([0,1]) => [[0,0],[1,1],[0,0]] }
      output_space = OutputSpace.new(size: 2)
      bmus_list.each_key{ |neuron| output_space.add(neuron) }
      umatrix = UMatrix.new(bmus_list, output_space)
      umatrix.create_grid!
      umatrix.grid.each_with_position do |avg, position|
          avg.should eql(umatrix.average_distance(umatrix.output_space[*position], bmus_list[umatrix.output_space[*position]]))
      end
    end
  end

  describe '#average_distance' do
    it "clalculates the average distance between a neuron and two input pattern" do
      umatrix = UMatrix.new({}, [])
      umatrix.average_distance( Neuron.new([1,1]) , [[1,1],[1,1]] ).should eql(0.0)
      first_distance = Math::sqrt(((1.2-1)**2 + (5.4-1)**2)) 
      second_distance = Math::sqrt(((1.2-3)**2 + (5.4-4)**2))
      umatrix.average_distance( Neuron.new([1.2,5.4]) , [[1,1],[3,4]] ).should eql((first_distance + second_distance) /2)
    end
  end
  describe '#neuron_location' do
    it "returns a list of the neurons and theire location in the outputspace" do
      bmus_list = { Neuron.new([1,1]) => [[0,0],[1,1],[0,0]],
                    Neuron.new([0,0]) => [[0,0],[0,0],[0,0]],
                    Neuron.new([1,0]) => [[1,1],[0,0],[0,0]],
                    Neuron.new([0,1]) => [[0,0],[1,1],[0,0]] }
      output_space = OutputSpace.new(size: 2)
      bmus_list.each_key{ |neuron| output_space.add(neuron) }
      umatrix = UMatrix.new(bmus_list, output_space)                 
      umatrix.neuron_location.to_a.each do |pair|
       umatrix.output_space[*pair.last].should eql(pair.first)
      end
    end
  end
  describe '#convert_to_colour' do
    it "converts the averages in a matrix to RGB colours" do
      umatrix = UMatrix.new({}, Array.new(2){Array.new(2)})
      umatrix.grid = Matrix.new(2){Array.new(2)}
      umatrix.grid[0][0] = 0
      umatrix.grid[0][1] = 1
      umatrix.grid[1][0] = 1
      umatrix.grid[1][1] = 0
      colour_matrix = umatrix.convert_to_colour
      colour_matrix[0][0].should eql(255) 
      colour_matrix[0][1].should eql(0)
      colour_matrix[1][0].should eql(0)
      colour_matrix[1][1].should eql(255)
    end
  end
end
