require_relative '../lib/som'
include SOM

describe Neuron do
  before :each do
    @n = Neuron.new([0,0,0])
  end

  describe '#to_image' do
    it "converts itself to an image" do
      expect(@n.to_image).to be_a Image
    end
  end
end
