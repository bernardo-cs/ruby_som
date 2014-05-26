require_relative 'functions'

module SOM
  class SOM
    include SOM::Functions
    attr_accessor :output_space, :input_patterns, :learning_rate, :radius, :bmus_position, :epochs, :umatrix, :initial_radius, :initial_learning_rate

    def initialize learning_rate: 0.6,
                   output_space_size: 4,
                   epochs: 100,
                   radius_type: :circular,
                   force_radius: nil
      @epochs = epochs
      @umatrix = Matrix.new( output_space_size ){ Array.new(output_space_size) }
      @learning_rate = learning_rate
      @bmus_position = {}
      @input_patterns = Matrix.new(4){ InputPattern.new(4){ rand 0..1 } } 
      @output_space = OutputSpace.new( size: output_space_size,radius_type: radius_type )
      @radius =  force_radius || (measures.max/2.0).round(0) 
      @initial_radius =  @radius
      @initial_learning_rate = @learning_rate
    end

    def epoch iteration=1, &block
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
      update!(iteration)
    end

    def create_umatrix file_name
      @umatrix = UMatrix.new( input_patterns_for_wn, @output_space )
      @umatrix.create_grid! 
      @umatrix.convert_to_colour!
      @umatrix.print_matrix(5,5,file_name: file_name)
    end

    def bmus
      input_patterns.inject({}){ | hash, input |  hash[input] = @output_space[*@bmus_position[input]]; hash }
    end

    def input_patterns_for_wn
      bmus.to_a.inject({}){ |hash, n| hash.has_key?(n.last) ? hash[n.last].push(n.first) : hash[n.last] = [n.first]; hash  }
    end

    def temporal_const
      @epochs/(Math::log(@radius))
    end
    def measures
      [@output_space.grid.size, @output_space.grid.first.size]
    end

    def update_bmus_position input_pattern, neuron_position
     @bmus_position[input_pattern] = neuron_position 
    end

    def exec_and_print_steps! output_folder
      FileUtils::mkdir_p (File.join(Dir.pwd,'images', output_folder))      
      step = 0
      exec!  do |som|
        som.output_space.print_matrix(5,5, file_name: "#{output_folder}\/#{step}_som.bmp")
        som.create_umatrix("#{output_folder}\/#{step}_som_umatrix.bmp")
        step =+ 1
      end
    end
    
    def exec! &block
      progress = ProgressBar.create(:title => "Will run #{@epochs} epochs", :starting_at => 0, :total => @epochs, :format => '%a %B %p%% %t')
      epochs.times{ |iteration| epoch(iteration); progress.increment; yield self if block_given? }
    end

    def update! iteration
      update_radius!(iteration) ; update_learning_rate!(iteration)
    end

    def update_radius! iteration 
      #@radius = (@radius/2)
      @radius = exponential_decay( initial_radius, temporal_const, iteration ).round(0) 
    end

    def update_learning_rate! iteration 
      @learning_rate = exponential_decay( initial_learning_rate, temporal_const, iteration )
    end

    def to_s
      @output_space.to_s + "\n" + @input_patterns.to_s
    end
  end
end
