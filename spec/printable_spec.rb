require_relative '../lib/som'

class DummyClass

end

describe Printable do
   before :each do
      @printable = DummyClass.new
      @printable.extend(Printable)
   end

   describe '#normalize_colour' do
     it "returns black when the first argument is equal to the max" do
      @printable.normalize_colour(8,1,8).should eql(Printable::BLACK) 
     end
     it "returns white when the first argument is equal to the min" do
      @printable.normalize_colour(1,1,8).should eql(Printable::WHITE) 
     end
     it "returns a value between 0 and 255, if the given argument is between max and min" do
       20.times{ @printable.normalize_colour(rand(1..20),1,20).should be_between(0, 255)  }
     end
     it "returns whiter colours, if numbers are smaller" do
       min,max = 4, 345
       @printable.normalize_colour(36,min,max).should be >= @printable.normalize_colour(50,min,max)  
       @printable.normalize_colour(50,min,max).should be >= @printable.normalize_colour(200,min,max)  
       @printable.normalize_colour(300,min,max).should be <= @printable.normalize_colour(200,min,max)  
     end
     # black is returned for nil because it repesents the biggest average distance
     it "returns the color black if it receives nil" do
       @printable.normalize_colour(nil,2,6).should eql(Printable::BLACK)
     end
   end
end
