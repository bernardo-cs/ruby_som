## Module used to create reports of the soms
## converts arrays to tweets

## @umatrix must be implemented in order to get bmus and input_patterns
## @binmatrix must be implemented in order to read the tweets

module SOM
  module Reportable
    def report
      File.open(report_file_name, 'w') { |f| @umatrix.bmus_list.each.with_index{ |a,i| f.puts "--- Neuron: #{i}"; a.last.each{ |t| f.puts @bin_matrix.read_tweet(t)} }}
    end

    private
    def report_folder
      File.join( Dir.pwd, 'results/' )
    end

    def report_file_name
      File.join(report_folder, Time.now.utc.iso8601 + '.txt')
    end
  end
end
