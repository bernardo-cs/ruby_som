require_relative '../lib/som'
include SOM

describe SOM do
  before :each do
    @som = SOM::SOM.new learning_rate: 0.6, radius: 0
    @som.input_patterns = Matrix.new([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]])
    [ SOM::Neuron.new( [0.2,0.6,0.5,0.9]  ),
      SOM::Neuron.new( [0.8,0.4,0.7,0.3]  ) ].each{ |neuron| @som.output_space.add( neuron  )  }
  end
  describe '#epoch' do
    it "runs one epoch of som trainning, output space should have tained neurons" do
      @som.epoch
      expect(@som.output_space.flat.map{ |a| a.round(3) unless a.nil? }).to include([0.968, 0.304, 0.112, 0.048],
                                                [0.032, 0.096, 0.68, 0.984] )
    end
  end
  describe 'bmus' do
    it "returns a list of input patterns and theyre best matching units (BMUs)" do
      @som.epoch
      @som.input_patterns.each do |input|
        @som.bmus[input].should eql(@som.output_space.find_winning_neuron(input))
      end
    end
  end
  describe 'bmus_position' do
    it 'returns a list of the input patterns, and the location of the BMUs' do
      @som.epoch
      @som.bmus_position.each_pair do |input, bmu_pos|
        winning_neuron = @som.output_space.find_winning_neuron(input)
        @som.output_space.find_neuron_position(winning_neuron).should eql(bmu_pos)
      end
    end
  end
end


