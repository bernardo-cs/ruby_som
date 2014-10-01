require_relative '../lib/som/neuron.rb'
require_relative '../lib/som/umatrix2.rb'
require_relative '../lib/som/output_space.rb'
include SOM

describe SOM::UMatrixBla do

  before :each do
    srand(67809)
  end

  describe '#init_grid' do
    it "calculates the average distance of a bmu and all his inputut patterns" do
      bmus_list = { Neuron.new([1,3]) => [[0,0],[1,1],[0,0]],
                    Neuron.new([0,0]) => [[0,0],[0,0],[0,0]],
                    Neuron.new([3,0]) => [[1,1],[0,0],[0,0]],
                    Neuron.new([0,5]) => [[0,0],[1,1],[0,0]] }
      output_space = OutputSpace.new(size: 2)
      bmus_list.each_key{ |neuron| output_space.add(neuron) }
      umatrix = SOM::UMatrixBla.new( output_space)
      umatrix.init_grid!
      umatrix.grid.should eq([[[0, 5], nil, [0, 0]], [nil, nil, nil], [[1, 3], nil, [3, 0]]])
      umatrix.exec!.should eq([[3.16, 5.0, 5.0], [2.24, 2.24, 3.0], [2.7, 3.61, 2.95]])
    end
  end
  describe '#convert_to_colour' do
    it "converts the averages in a matrix to RGB colours" do
      umatrix = UMatrixBla.new(Array.new(2){Array.new(2)})
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
