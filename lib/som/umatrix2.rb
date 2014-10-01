require_relative './printable.rb'
require_relative './matrixable.rb'
module SOM
  class UMatrixBla
    include Printable
    include Matrixable
    attr_accessor :bmus_list, :output_space, :grid, :export_path

    def initialize( output_space,
                   export_path: File.join(Dir.pwd,'images'))
      @export_path = export_path
      @output_space = output_space
      @grid = Matrix.new(output_space.size + (output_space.size - 1)){ Array.new(output_space.size + output_space.size - 1){ } }
    end

    # adds neurons to the umatrix
    def init_grid!
      @output_space.grid.each_with_position{|n,cord| @grid[get_position(cord.first),get_position(cord.last)] = n}
    end

    # calculates intermediate values
    def exec!
      @grid.each_with_position do |n,cord|
        # Search to the right of the matrix
        if !n.nil? && !@grid[cord.first, cord.last + 2].nil? && !(n.is_a? Numeric)
           @grid[cord.first, cord.last + 1] = real_distance(@grid[*cord], @grid[cord.first, cord.last + 2] )
        end
        # Search down the matrix
        if !n.nil? && !@grid[cord.first + 2].nil? && !(n.is_a? Numeric)
           @grid[cord.first + 1, cord.last] = real_distance(@grid[*cord],@grid[cord.first + 2, cord.last ])
        end
        # search in diagonal
        if !n.nil? && !@grid[cord.first + 2].nil? && !@grid[cord.first + 2, cord.last + 2 ].nil? && !(n.is_a? Numeric)
          diag1 = real_distance(@grid[*cord],@grid[cord.first + 2, cord.last + 2 ])
          diag2 = real_distance(@grid[cord.first, cord.last + 2],@grid[cord.first + 2, cord.last ])
           @grid[cord.first + 1, cord.last + 1] = (diag1+diag2)/2.0
        end
      end
      # remove neurons
      @grid.each_with_position do |n,cord|
        unless n.class == Float
          values = []
          ( -1..1 ).each do |x|
            ( -1..1 ).each do |y|
             values << @grid[cord.first + x,cord.last + y] if !( x == 0 && y == 0 ) && !((cord.first + x < 0) || (cord.last + y < 0   )) && (cord.first + x < @grid.size) && (cord.last + x < @grid.size)
            end
          end
          values = values.select{|n| !n.nil? }
          @grid[*cord] = (values.reduce(:+) / values.size.to_f).round(2)
        end
      end
    end

    def create_grid!
     self.init_grid!
     self.exec!
    end

    # returns the position of a neuron in the umatrix
    def get_position coordinate
      coordinate * 2
    end
    def distance array1, array2
      array1.zip(array2).map{ |a| a.reduce(:-)**2 }.reduce(:+)
    end
    def real_distance array1, array2
      Math::sqrt( distance(array1, array2) ).round(2)
    end
    #def create_grid!
      #@bmus_list.each_pair{ |neuron, input_patterns| self[*neuron_location[neuron]] = average_distance(neuron, input_patterns) }
    #end

    #def average_distance neuron, input_patterns
       #input_patterns.map{ |i| neuron.real_distance(i) }.instance_eval{ reduce(:+) / size.to_f }
    #end

    #def neuron_location
      #@output_space.build_neuron_position_cache
    #end

    def convert_to_colour(min =nil, max = nil)
     min ||= @grid.find_min
     max ||= @grid.find_max
     @colour_matrix =  Matrix.new(@grid.size){ Array.new(@grid.size) }
     @grid.each_with_position do |avg, pos|
       @colour_matrix[pos.first][pos.last] = normalize_colour(avg, min, max)
     end
     @colour_matrix
    end

    def convert_to_colour!(min =nil, max = nil)
      @grid = convert_to_colour(min, max)
    end
  end
end
