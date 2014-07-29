## Module used to create reports of the soms
## converts arrays to tweets

## @umatrix must be implemented in order to get bmus and input_patterns
## @input_patterns must be implemented in order to read the tweets
#  inputt_patterns must be of type BinMatrix

module SOM
  module Reportable
    ## yields:
    #  f file to write
    #  i neuron number
    #  t tweet text trimmed
    def report file_name = report_file_name(), report_neuron_text: false, &block
      File.open(file_name, 'w') do |f|
        each_bmu_with_index do |a,i|
          f.puts "--- Neuron: #{i}"
          f.puts(  neuron_text_report(i) ) if report_neuron_text
          ip_for_neuron(a){ |t| block_given? ? yield(f,i, @input_patterns.read_tweet(t) ) : f.puts( @input_patterns.read_tweet(t) )}
        end
      end
    end

    def neurons_text_stats
      @umatrix.bmus_list.to_a.inject({}) do |hsh, n|
        hsh[n.first] = text_report( neuron_text( n.last ) )
        hsh
      end
    end

    def  neuron_text_report neuron_index
      neuron = @umatrix.bmus_list.to_a[ neuron_index ].first
      neurons_text_stats[neuron].inject("") do |str,n|
        str << n.first << "\t\t" << n.last.to_s << "\n"
      end
    end

    private
    def neuron_text ip
      ip.inject(""){ |sum,i| sum << @input_patterns.read_tweet( i ) << " "}
    end

    def text_report str
       str.split(' ').uniq.map{ |w| [w, str.split(' ').count( w )] }.sort{ |a| a.last }
    end

    def each_bmu_with_index &block
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
