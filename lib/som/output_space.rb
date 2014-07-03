## Two Dimensions, squared SOM Grid
module SOM
  class OutputSpace
    attr_accessor  :grid, :export_path
    include Enumerable
    include Matrixable
    include Printable

    alias_method :get_neurons_in_radius, :get_elements_in_radius 
    alias_method :find_neuron_position, :find_element_position 
    alias_method :get_all_neurons, :get_all_elements
    alias_method :add_neuron_at_pos, :add_element_at_pos
    alias_method :neurons_size, :elements_size
    alias_method :build_neuron_position_cache, :build_element_position_cache
    alias_method :get_neurons_in_circular_radius_with_distance, :get_elements_in_circular_radius_with_distance
    alias_method :get_neurons_in_circular_radius, :get_elements_in_circular_radius

    alias_method :update_neuron_at_position, :add_element_at_pos 

    def initialize size: 10,
                   radius_type: :circular,
                   export_path: File.join(Dir.pwd,'images')  
      @grid = Matrix.new(size){ Array.new(size) }
      @export_path = export_path
      @size = size
      @radius_type = radius_type if RADIUS_TYPES.include?(radius_type)
    end

    def find_winning_neuron input_pattern
      inject {|memo, neuron| memo.distance(input_pattern) < neuron.distance(input_pattern) ? memo : neuron }
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
