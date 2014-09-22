require_relative '../lib/som'
include SOM

describe OutputSpace do
  before :each do
    @output_space = OutputSpace.new( size: 3, radius_type: :square )

    @output_space.grid = [[Neuron.new([1,1,1]), Neuron.new([2,2,2]), Neuron.new([3,3,3])],
                          [Neuron.new([4,4,4]), Neuron.new([5,5,5]), Neuron.new([6,6,6])],
                          [Neuron.new([7,7,7]), nil, Neuron.new([9,9,9])]
                         ]
  end
  describe '#add' do
    it 'adds a neuron to the grid, if the grid is full, should return false' do
      @output_space.add(Neuron.new([8,8,8]))
      @output_space.should include(Neuron.new([8,8,8]))
      @output_space.add(Neuron.new([8,8,8])).should be false
    end
  end
  describe '#find_neuron_position' do
    it 'returns an array with the position of the passed neuron' do
      @output_space.find_neuron_position(Neuron.new([5,5,5])).should eq([1,1])
    end
    it 'returns nil if the neuron is not present in the grid' do
      @output_space.find_neuron_position(Neuron.new([6,7,8])).should be_nil
    end
  end
  describe '#get_neurons_in_radius' do
    it 'returns the neurons inside a square with center c, and radir r' do
      c,r = [1,1], 1
      @output_space.get_neurons_in_radius( c, r ).should eql(@output_space.get_all_neurons)
    end
    it 'accepts radius that get out of the grid' do
      @output_space.get_neurons_in_radius([0,0], 1).size.should eql(4)
    end
    it 'returns only one neuron when radius is 0' do
      @output_space.get_neurons_in_radius([1,1], 0).should include(Neuron.new([5,5,5]))
    end
  end
  describe '#full?' do
    it "returns true if grid is full" do
      @output_space.add(Neuron.new([1,2,3,4]))
      @output_space.full?.should be true
    end
    it "returns false if grid still has available positions" do
      @output_space.full?.should be false
    end
  end
  describe '#get_all_neurons' do
    it 'retruns an array with all the neurons, nils are not returned' do
      @output_space.get_all_neurons.should eql(@output_space.grid.flat_map{|a| a }.reject{ |n| n.nil? })
    end
  end
  describe '#update_neuron_at_position' do
    it 'inserts a new neuron in the grid' do
      @output_space.update_neuron_at_position( Neuron.new([3,4,5]), [0,0] )
      @output_space[0,0].should eql(Neuron.new([3,4,5]))
    end
  end
  describe '#find_winning_neuron' do
    it "a neuron with the same coordinates as an input pattern will always be the winning neuron" do
      @output_space.find_winning_neuron([1,1,1]).should eql(Neuron.new([1,1,1]))
      @output_space.find_winning_neuron([2,2,2]).should eql(Neuron.new([2,2,2]))
      @output_space.find_winning_neuron([4,4,4]).should eql(Neuron.new([4,4,4]))
    end
    it 'returns the nearest neuron even with decimal coordinates' do
      @output_space.find_winning_neuron([4.2,4.1,4.5]).should eql(Neuron.new([4,4,4]))
    end
  end
  describe '#each' do
    it "lets you iterate through all the neurons in the grid, nils are not returned" do
      @output_space.each do |neuron|
        expect(@output_space.grid.flat_map{ |a| a }).to include(neuron)
      end
    end
    it "verifies that all the neurons n the grid are yielded with each" do
      neurons_arr = []
      @output_space.each do |neuron|
        neurons_arr << neuron
      end
     expect( @output_space.grid.flat_map{ |a| a }.reject{ |a| a.nil? }).to include(*neurons_arr)

    end
  end
  describe '#each_row' do
    it "iterates over each row" do
      n = 0
      @output_space.each_row do |row|
        case n
        when 0
          row.should eql([Neuron.new([1,1,1]), Neuron.new([2,2,2]), Neuron.new([3,3,3])])
        when 1
          row.should eql([Neuron.new([4,4,4]), Neuron.new([5,5,5]), Neuron.new([6,6,6])])
        when 2
          row.should eql([Neuron.new([7,7,7]), nil, Neuron.new([9,9,9])])
        end
        n += 1
      end

    end
  end
  describe '#neurons_size' do
    it "returns the size of the neurons (number of dimensions)" do
      @output_space.neurons_size.should eql(3)
    end
  end
  describe '#print_matrix' do
    it "prints an image file" do
     @output_space.print_matrix(5,5)
     File.exist?('som.bmp').should be_truthy
    end
  end
  describe '#[]' do
    it "returns the neuron in the specified position" do
      @output_space[0,0].should eql(@output_space.grid.first.first)
      @output_space[2,2].should eql(@output_space.grid.last.last)
    end
    it "returns nil, if the coordinates are out of bounds" do
      @output_space[69,70].should be_nil
    end
    it "returns nil, for negative numbers" do
      @output_space[-3,-5].should be_nil
    end
  end

  describe '#[]=' do
    it "associates a neuron to the specifiend position" do
      @output_space[0,0] = Neuron.new([1,2,3])
      @output_space[0,0].should eql(Neuron.new([1,2,3]))
    end
  end

  describe '#get_empty_positions' do
    it "should return an array with the avaylable positions in the grid" do
      expect(@output_space.get_empty_positions).to include([2,1])
    end
    it "should be able to respond to a block with empty postions" do
      @output_space.get_empty_positions{ |empty_position| empty_position.should eql([2,1])}
    end
  end
end
