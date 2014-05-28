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

    def all_values
      flat.select{ |n| !n.nil? }
    end

    def avg
     all_values.instance_eval { reduce(:+) / size.to_f }
    end

    ## TODO: find_min, find_max without ifs for nils
    def find_min
      all_values.inject{ |min, val| min < val ? min : val }
    end

    def find_max
      all_values.inject{ |max, val| max > val ? max : val }
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
