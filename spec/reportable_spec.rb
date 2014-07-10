require_relative '../lib/som/reportable'
require_relative "../../data_parser/lib/data_parser/bin_matrix.rb"
require 'tempfile'

describe Reportable do
  before :each do
    @input_array = []
    @input_array << "253583303901327362,BestYouNevrHad,ayrikahnichole xbox\n"
    @input_array << "253583300558454785,myhiroto_bot,yuda xbox hono\n"
    @input_array << "253583301900640256,Yung_Cino,cazorla playing imp\n"
    @bin_matrix = BinMatrix.new( Tempfile.new('csv_matrix').path  , @input_array, 2)
    @som = SOM::SOM.new learning_rate: 0.6,
                        epochs: 1,
                        output_space_size: 5,
                        input_patterns: @bin_matrix
    @som.exec!
    @som.create_umatrix
  end
 
   describe 'report' do
     it "creates a file with the report of the train performed" do
       file = Tempfile.new('report') 
       @som.report(file.path)
       file.rewind
       File.read(file.path).should eql("--- Neuron: 0\nayrikahnichole xbox\n--- Neuron: 1\nxbox yuda hono\n--- Neuron: 2\ncazorla playing imp\n")
     end
   end
end
