require_relative '../lib/som/matrix.rb'
include SOM

describe Matrix do
  before :each do
    @matrix = Matrix.new([[1,2,3],[4,5,6],[7,8,9]])
  end

  describe 'each_value' do
   it "yealds each value inside the matrix" do
     @matrix.each_value do |val|
       @matrix.flat_map{ |a| a }.should include(val)
     end
   end

   describe '#full' do
     it "returns true if matrix is full" do
       @matrix.full?.should be_truthy
     end
     it "returns false if the matrix has nils" do
       @matrix[1][2] = nil
       @matrix.full?.should be_falsey
     end
   end

   describe '#flat' do
     it "turns the matrix into an array of values" do
       @matrix.flat.should eql([1,2,3,4,5,6,7,8,9])
     end
   end

   describe '#open_positions' do
     it "returns the number of nils in each row" do
       @matrix[1][2] = nil
       @matrix.open_positions.should eql([0,1,0])
     end
   end

   describe '#each_with_position' do
     it "yields each value and its position" do
       @matrix.each_with_position do |val, pos|
         @matrix[pos.first][pos.last].should eql(val)
       end
     end
   end

   describe '#all_values' do
     it "returns an array with all the values of a matrix, does not return nils" do
       @matrix[0][0] = nil
       @matrix.all_values.should eql([2,3,4,5,6,7,8,9])
     end

   end

   describe '#find_min' do
     it "finds the minimum value on the matrix" do
       @matrix.find_min.should eql(1)
       @matrix[1][2] = -234
       @matrix.find_min.should eql(-234)
     end
     it "ignores nils" do
       @matrix[1][1] = nil
       @matrix.find_min.should eql(1)
     end
   end

   describe '#find_max' do
     it "finds the maximum value on the matrix" do
       @matrix.find_max.should eql(9)
       @matrix[1][2] = 99
       @matrix.find_max.should eql(99)
     end
   end
  end

  describe '[]=' do
    it "associates a value to a position of a matrix" do
      @matrix[0,1] = 1000
      @matrix[0][1].should eql(1000)
      @matrix[0].size.should eql(3)
    end
  end
  describe '#avg' do
    it "calculates the average of all matrix values" do
      @matrix.avg.should eql(5.0)
    end
  end
end
