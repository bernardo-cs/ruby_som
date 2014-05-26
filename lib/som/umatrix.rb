module SOM
  class UMatrix 
    include Printable
    attr_accessor :bmus_list, :output_space, :grid, :export_path

    def initialize(bmus_list, output_space, 
                   export_path: File.join(Dir.pwd,'images'))  
      @export_path = export_path
      @bmus_list = bmus_list
      @output_space = output_space
      @grid = Matrix.new(output_space.size){ Array.new(output_space.size){ } }
    end
 
    def create_grid!
      @bmus_list.each_pair{ |neuron, input_patterns| self[*neuron_location[neuron]] = average_distance(neuron, input_patterns) }
    end

    def average_distance neuron, input_patterns
      input_patterns.inject(neuron.real_distance(input_patterns.first)){ |avg, ip| avg = ((avg + ((neuron.real_distance(ip))))/2); avg  }
    end

    def size
      @grid.size
    end
    
    def first_row
      @grid.first
    end

    def neuron_location
      @output_space.build_neuron_position_cache
      #TODO: The next line is this function with cache. Very pretty for 
      #      long executions, but fucks up printing every step of a som 
      #      train
      #neuron_location ||= @output_space.build_neuron_position_cache
    end

    def convert_to_colour
     @colour_matrix =  Matrix.new(@output_space.size){ Array.new(@output_space.size) } 
     min, max = @grid.find_min, @grid.find_max
     @grid.each_with_position do |avg, pos|
       @colour_matrix[pos.first][pos.last] = normalize_colour(avg, min, max)
     end
     @colour_matrix
    end

    def convert_to_colour!
      @grid = convert_to_colour
    end

    def each_row(&block)
      @grid.each(&block)
    end

    def [](x,y)
      @grid[x][y]
    end

    def []=(x,y,neuron)
      @grid[x][y] = neuron
    end 
  end
end
