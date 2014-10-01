require_relative './printable.rb'
module SOM
  class Neuron < Array
    include Printable

    ##NOTE: not the real euclidian distance, sqrt not performed for performance
    def distance array
      zip(array).map{ |a| a.reduce(:-)**2 }.reduce(:+)
    end
    def real_distance array
      Math::sqrt( distance(array) )
    end
    def learn input_pattern, learning_rate
      Neuron.new( learn_function(input_pattern, learning_rate) )
    end
    def learn_function input_pattern, learning_rate
      map{ |x| x*(1-learning_rate) }.zip( input_pattern.map{ |x| x*learning_rate } ).map do |x|
        x.first + x.last
      end
    end
    def learn! input_pattern, learning_rate
      replace( learn_function(input_pattern, learning_rate) )
    end
    def round n
      map{ |a| a.round(n) }
    end
    def to_s
      str = "["
      map do |n|
        splited_first, splited_second = "",""
        splited_n = n.round(2).to_s.split('.')
        while (splited_n.first.size <= 2) do
          splited_first = splited_n.first.insert(0,'0')
        end
        while (splited_n.last.size <= 2) do
          splited_second = splited_n.last << '0'
        end
        n = splited_first + "." + splited_second
      end.each do |n|
       str << n
       str << ","
      end
      str = str[0..-3]
      str << "]"
    end
  end
end
