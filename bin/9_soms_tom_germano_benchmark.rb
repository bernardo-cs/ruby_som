require "benchmark"#require 'pry'
require_relative '../lib/som.rb'
#require 'benchmark'

## Initialize the Output Space randomly
#  A) Initialize the SOM with 100 random neurons,
#     add 1000 random input patterns
def benchmark_runs &block
  time = Benchmark.measure do
    yield
  end.total
end

def run_som out_space_size, in_pattern_size, in_pattern_number, epochs = 1
  som = SOM::SOM.new output_space_size: out_space_size,
    epochs: epochs

  (out_space_size**2).times{ som.output_space.add(SOM::Neuron.new(in_pattern_size){ rand 0..255 }) }

  som.min = 0
  som.input_patterns = in_pattern_number.times.inject([]){ |arr| arr << Array.new(in_pattern_size){ rand(0..255) }; arr  }

  som.exec!
  benchmark_runs do
    som.input_patterns.each do |i|
      som.output_space.find_winning_neuron i
    end
  end
end


@f =  File.open('megabenchamrking.tsv','w')
@f.puts "out_size\tin_size\tin_pattern_numb\ttrain_time\tidentification_time\tepochs"
def build_tsv &block
  out_size, in_size, in_pattern_number, train_time, ident_timex, e = *yield
  @f.puts out_size.to_s + "\t" + in_size.to_s + "\t" + in_pattern_number.to_s + "\t" + train_time.round(3).to_s + "\t" + ident_timex.round(3).to_s + "\t" + epochs.to_s
end

def main
  epochs = [1,2,3,4,5,6,7,8]
  out_space_sizes = [1,5,10,50]
  in_pattern_size = [3,10,100,1000]
  in_pattern_number = [100,1000,10000,100000]

  epochs.each do |e|
    out_space_sizes.each do |o|
      in_pattern_size.each do |is|
        in_pattern_number.each do |inp|
          after_train_time  = :notset
          train_time = benchmark_runs do
            after_train_time = run_som( o,is,inp,e  )
          end
          build_tsv do
            [o,is,inp,train_time,after_train_time,e]
          end
        end
      end
    end
  end
end
main()
@f.close
