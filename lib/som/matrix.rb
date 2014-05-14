module SOM
  class Matrix < Array
    def full?
      open_positions().inject(0){|memo, n| memo = memo+n} == 0 ? true : false
    end
    def not_full?
      !full?
    end
    def open_positions
      #TODO find a simpler way to find nils in arrays
     map{|vec| vec.find_all{|n| n.nil?}}.map{|vec| vec.inject(0){|memo, value| memo = memo+1 if value.nil?} } 
    end
    def to_s
      map{ |a| a.map{ |i| i.nil? ? "_" : i.to_s}.join(',') }.to_s
    end
  end
end
