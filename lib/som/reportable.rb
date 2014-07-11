## Module used to create reports of the soms
## converts arrays to tweets

## @umatrix must be implemented in order to get bmus and input_patterns
## @input_patterns must be implemented in order to read the tweets

module SOM
  module Reportable
    ## yields:
    #  f file to write
    #  t tweet text trimmed
    #  i neuron number
    def report file_name = report_file_name(), &block
      File.open(file_name, 'w') { |f| each_bmu_with_index{ |a,i| f.puts "--- Neuron: #{i}"; ip_for_neuron(a){ |t| block_given? ? yield(f,i, @input_patterns.read_tweet(t) ) : f.puts( @input_patterns.read_tweet(t) )} }}
    end

    #def report_with_text file_name = report_file_name_with_text()
      #File.open(file_name, 'w') { |f| @umatrix.bmus_list.each.with_index{ |a,i| f.puts "--- Neuron: #{i}"; a.last.each{ |t| f.puts convert_stemmed_text_to_text( @input_patterns.read_tweet(t) )} }}
    #end

    private
    def  each_bmu_with_index &block
      @umatrix.bmus_list.each.with_index( &block )
    end

    def ip_for_neuron pair, &block
       pair.last.each( &block )
    end

    def report_folder
      File.join( Dir.pwd, 'results/' )
    end

    def report_file_name
      File.join(report_folder, Time.now.utc.iso8601 + '.txt')
    end
  end
end
