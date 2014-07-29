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

     it "can report with neuron text resume" do
       file = Tempfile.new('report2')
       @som.report(file.path, report_neuron_text: true)
       file.rewind
       File.read(file.path).should eql("--- Neuron: 0\nxbox\t\t1\nayrikahnichole\t\t1\nayrikahnichole xbox\n--- Neuron: 1\nhono\t\t1\nyuda\t\t1\nxbox\t\t1\nxbox yuda hono\n--- Neuron: 2\nimp\t\t1\nplaying\t\t1\ncazorla\t\t1\ncazorla playing imp\n")
     end

     it "yields the file, tweets text trimmed and neuron number" do
       file = Tempfile.new('report2')
       @som.report(file.path){ |file, neuron_number, tweet| file.puts( tweet.to_s + ' ola' )}
       file.rewind
       File.read(file.path).should eql("--- Neuron: 0\nayrikahnichole xbox ola\n--- Neuron: 1\nxbox yuda hono ola\n--- Neuron: 2\ncazorla playing imp ola\n")
     end
   end

   describe 'neurons_text_report' do
     it "gets the text present in all inputt patterns associated with a neuron" do
       @som.neurons_text_stats.first.last.should include( ["ayrikahnichole",1],["xbox",1] )
       @som.neurons_text_stats.to_a.last.last.should include( ["cazorla",1],["playing",1],["imp",1] )
       @som.neurons_text_stats[@som.umatrix.bmus_list.first.first].should include( ["ayrikahnichole",1],["xbox",1] )
     end
   end
end
