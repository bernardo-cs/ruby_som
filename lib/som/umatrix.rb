require_relative 'matrix.rb'
module SOM
  class UMatrix 
    attr_accessor :bmus_list, :output_space, :grid

    def initialize(bmus_list, output_space)
      @bmus_list = bmus_list
      @output_space = output_space
      @grid = Matrix.new(output_space.size){ Array.new(output_space.size){ } }
    end
 
    def create_grid!
      @bmus_list.each_pair{ |neuron, input_patterns| self[*neuron_location[neuron]] = average_distance(neuron, input_patterns) }
    end

    def average_distance neuron, input_patterns
      input_patterns.inject(neuron.real_distance(input_patterns.first)){ |avg, ip| avg = ((avg + ((neuron.real_distance(ip))))/2); avg }
    end

    def neuron_location
      neuron_location ||= @output_space.build_neuron_position_cache
    end

    def [](x,y)
      @grid[x][y]
    end

    def []=(x,y,neuron)
      @grid[x][y] = neuron
    end 
  end
end
