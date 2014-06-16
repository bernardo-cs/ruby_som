module Matrixable
  RADIUS_TYPES = [:circular, :square].freeze
  def size
    @grid.size
  end

  def flat (&block)
    @grid.flat_map do |a|
      yield a if block_given?
      a
    end
  end

  def first_row
    @grid.first
  end

  def each_row(&block)
    @grid.each(&block)
  end

    ##TODO full? calls get_empty_positions
     #      without caching is ineficient
    def add element
     return false if full? 
     self[*get_empty_positions.sample] = element
    end

    def get_all_elements
      arr = []
      self.each{ |element| arr << element }
      arr
    end

    def find_element_position element
      position = [nil,nil]
      @grid.each_with_index do |column, column_index|
        column.each_with_index do |n, row_index|
          position[0],position[1] = column_index,row_index if element == n
        end
      end
      position.first.nil? ? nil : position
    end

     def get_elements_in_radius center, radius
      elements = []
      x_borders = [center.first - radius, center.first + radius]
      y_borders = [center.last - radius, center.last + radius]
      (x_borders.first..x_borders.last).each do |x_cord|
        (y_borders.first..y_borders.last).each do |y_cord|
          element = self[x_cord, y_cord]
          elements << element unless element.nil?
        end
      end
      elements
    end 

    def get_empty_positions &block
      @grid.each.with_index.inject([]) do |array, (row, row_number)|
        row.each.with_index do |element, column_number|
        array << [row_number, column_number] if element.nil?
        yield array.last if block_given? && element.nil?
        array
      end 
      array
      end
    end

    def each
      @grid.each{|column| column.each{|element| yield element unless element.nil? }}
    end

  def [](x,y)
    return nil if x < 0 || y < 0 || x >= @grid.size || y >= @grid.first.size
    @grid[x][y]
  end

  def []=(x,y,element)
    @grid[x][y] = element
  end     

  #methods dependent on other methods
  def build_element_position_cache
    get_all_elements.inject({}){ |hash, n| hash[n] = find_element_position(n); hash }
  end

  def add_element_at_pos element, position
    self[position.first, position.last] = element 
  end

  def full?
    get_empty_positions.count == 0 ? true : false
  end

  ##TODO: Just get the first element that appears, instead of all
  def elements_size
    get_all_elements.first.size
  end

    def get_elements_in_circular_radius_with_distance center, radius, &block
      get_elements_in_radius(center,radius).each do |element|
        element_position = find_element_position( element )
        distance = Math::sqrt(center.zip(element_position).map{ |x| x.reduce(:-)  }.map{|x| x**2}.reduce(:+)) 
        yield element, distance if distance <= radius
      end
    end

    def get_elements_in_circular_radius center, radius
      elements = []
      get_elements_in_radius(center,radius).each do |element|
        element_position = find_element_position( element )
        elements << element if Math::sqrt(center.zip(element_position).map{ |x| x.reduce(:-)  }.map{|x| x**2}.reduce(:+)) <= radius
      end
      elements
    end

end
