## Two Dimensions, squared SOM Grid
module SOM
  class OutputSpace
    attr_accessor  :grid, :export_path
    include Enumerable
    include Printable
    RADIUS_TYPES = [:circular, :square].freeze

    def initialize size: 10,
                   radius_type: :circular,
                   export_path: File.join(Dir.pwd,'images')  
      @grid = Matrix.new(size){ Array.new(size) }
      @export_path = export_path
      @size = size
      @radius_type = radius_type if RADIUS_TYPES.include?(radius_type)
    end

     ##TODO full? calls get_empty_positions
     #      without caching is ineficient
    def add neuron
     return false if full? 
     self[*get_empty_positions.sample] = neuron
     #x_cord,y_cord  = rand(0..@size-1),rand(0..@size-1)
     #self[x_cord,y_cord].nil?  ? self[x_cord,y_cord] = neuron : add(neuron)
    end

    def get_empty_positions &block
      @grid.each.with_index.inject([]) do |array, (row, row_number)|
        row.each.with_index do |neuron, column_number|
          array << [row_number, column_number] if neuron.nil?
          yield array.last if block_given? && neuron.nil?
          array
        end 
        array
      end
    end

    def first_row
      @grid.first
    end

    def build_neuron_position_cache
      get_all_neurons.inject({}){ |hash, n| hash[n] = find_neuron_position(n); hash }
    end

    def find_neuron_position neuron
      position = [nil,nil]
      @grid.each_with_index do |column, column_index|
        column.each_with_index do |n, row_index|
          position[0],position[1] = column_index,row_index if neuron == n
        end
      end
      position.first.nil? ? nil : position
    end

    def full?
      get_empty_positions.count == 0 ? true : false
    end

    def get_neurons_in_radius center, radius
      neurons = []
      x_borders = [center.first - radius, center.first + radius]
      y_borders = [center.last - radius, center.last + radius]
      (x_borders.first..x_borders.last).each do |x_cord|
        (y_borders.first..y_borders.last).each do |y_cord|
          neuron = self[x_cord, y_cord]
          neurons << neuron unless neuron.nil?
        end
      end
      neurons
    end

    def get_neurons_in_circular_radius_with_distance center, radius, &block
      get_neurons_in_radius(center,radius).each do |neuron|
        neuron_position = find_neuron_position( neuron )
        distance = Math::sqrt(center.zip(neuron_position).map{ |x| x.reduce(:-)  }.map{|x| x**2}.reduce(:+)) 
        yield neuron, distance if distance <= radius
      end
    end
    def get_neurons_in_circular_radius center, radius
      neurons = []
      get_neurons_in_radius(center,radius).each do |neuron|
        neuron_position = find_neuron_position( neuron )
        neurons << neuron if Math::sqrt(center.zip(neuron_position).map{ |x| x.reduce(:-)  }.map{|x| x**2}.reduce(:+)) <= radius
      end
      neurons
    end

    def get_all_neurons
      arr = []
      self.each{ |neuron| arr << neuron }
      arr
    end

    def update_neuron_at_position neuron, position
      add_neuron_at_pos neuron, position
    end
    
    def add_neuron_at_pos neuron, position
     self[position.first, position.last] = neuron 
    end

    def find_winning_neuron input_pattern
      inject do |memo, neuron|
        memo.distance(input_pattern) < neuron.distance(input_pattern) ? memo : neuron
      end
    end

    def each
      @grid.each{|column| column.each{|neuron| yield neuron unless neuron.nil? }}
    end

    def each_row
      @grid.each{ |row| yield row }
    end

    def flat (&block)
      @grid.flat_map do |a|
        yield a if block_given?
        a
      end
    end
    ##TODO: Just get the first neuron that appears, instead of all
    def neurons_size
      get_all_neurons.first.size
    end

    def []=(x,y,neuron)
      @grid[x][y] = neuron
    end

    def [](x,y)
      ## Return nil if coordinates are beyond the grid boundaries
      return nil if x < 0 || y < 0 || x >= @grid.size || y >= @grid.first.size
      @grid[x][y]
    end
    
    def size
      @grid.size
    end

     def []=(x,y,neuron)
      @grid[x][y] = neuron
    end

    def [](x,y)
      ## Return nil if coordinates are beyond the grid boundaries
      return nil if x < 0 || y < 0 || x >= @grid.size || y >= @grid.first.size
      @grid[x][y]
    end
    
    def size
      @grid.size
    end

    def to_s
      str = "    \t" 
      (0..(@size-1)).each{|n| str << " "*neurons_size*4 << "x" + n.to_s + "\t     \t" }
      str << "\n"
      @grid.each_with_index do |row,index|
        str << "y#{index}:\t[ "
        row.each do |neuron|
          str << if neuron.nil?
            ("  " + ("       " * neurons_size) + (""*(neurons_size-1)) + "  ")
          else
            neuron.to_s
          end
          str << ","
        end
        str = str[0..-3]
        str << " ]\n"
      end
      str
    end
  end
end
