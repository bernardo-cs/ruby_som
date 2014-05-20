module SOM
  class Matrix < Array
    def full?
      open_positions().inject(0){|memo, n| memo = memo+n} == 0 ? true : false
    end

    def each_value
      flat.each{ |val| yield val  }
    end

    def not_full?
      !full?
    end

    def flat 
      flat_map{ |a| a }
    end

    def open_positions
      #TODO find a simpler way to find nils in arrays
      map{|vec| vec.find_all{|n| n.nil?}}.map{|vec| vec.inject(0){|memo, value| memo = memo+1 if value.nil?} }
    end

    def to_s
      map{ |a| a.map{ |i| i.nil? ? "_" : i.to_s}.join(',') }.to_s
    end

    def find_min
      flat.inject{|min, val| min < val ? min : val}
    end

    def find_max
      flat.inject{|max, val| max > val ? max : val}
    end

    def each_with_position &block
      each.with_index do |row, row_index|
        row.each.with_index do |pos, column_index|
          yield pos, [row_index,column_index]
        end
      end
    end
  end
end
