require_relative 'input_pattern'
require_relative 'matrix'
require 'ruby-progressbar'

module SOM
  class SOM
    attr_accessor :output_space, :input_patterns, :learning_rate, :radius, :bmus_position, :epochs

    def initialize learning_rate: 0.6,
                   radius: 0,
                   output_space_size: 4,
                   epochs: 100 
      @epochs = epochs
      @radius = radius
      @learning_rate = learning_rate
      @bmus_position = {}
      @output_space = OutputSpace.new( output_space_size )
      @input_patterns = Matrix.new(4) { InputPattern.new(4){ rand 0..1 } } 
    end

    def epoch &block
      input_patterns.each do |input_pattern|
        wn = output_space.find_winning_neuron(input_pattern)
        wn_position = output_space.find_neuron_position(wn)
        update_bmus_position( input_pattern, wn_position )
        output_space.get_neurons_in_circular_radius(wn_position, radius).each do |neuron|
          updated_neuron_position = output_space.find_neuron_position(neuron)
          updated_neuron = neuron.learn(input_pattern, learning_rate)
          output_space.update_neuron_at_position(updated_neuron, updated_neuron_position)
        end
      end
      update!
    end

    def bmus
      input_patterns.inject({}){ | hash, input |  hash[input] = @output_space[*@bmus_position[input]]; hash }
    end

    def update_bmus_position input_pattern, neuron_position
     @bmus_position[input_pattern] = neuron_position 
    end

    def exec! &block
      progress = ProgressBar.create(:title => "Will run #{@epochs} epochs", :starting_at => 0, :total => @epochs, :format => '%a %B %p%% %t')
      epochs.times{ both_have_converged? ? break : epoch; progress.increment; yield self if block_given? }
    end

    def both_have_converged?
      learning_rate_converged? || radius_converged?
    end

    def learning_rate_converged?
      Float(learning_rate).round(3) == 0 
    end

    def radius_converged?
      Float(radius).round(0) == 0
    end

    def update!
      update_radius! ; update_learning_rate!
    end

    def update_radius!
      @radius = (@radius/2)
    end

    def update_learning_rate!
      @learning_rate = (@learning_rate/2)
    end

    def to_s
      @output_space.to_s + "\n" + @input_patterns.to_s
    end
  end
end
