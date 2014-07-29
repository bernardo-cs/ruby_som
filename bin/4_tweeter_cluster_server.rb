require_relative "../../dataset_mapper/lib/dataset_mapper"
require_relative "../../data_parser/lib/data_parser/bin_matrix.rb"
require_relative "../../som/lib/som"

include DatasetMapper

@dataset_path = '/home/bersimoes/coding/twitter_data_francisco/decompressed'
@base_file = 'tweets01_aaaa'
@default_data = :with_stem

puts 'Dataset statistics'
puts inspect_dataset_stats

@csv_matrix_file = Tempfile.new('csv_matrix')
@bin_matrix = BinMatrix.new( @csv_matrix_file.path, tweets_in_selected_words.uniq, 0)

som = SOM::SOM.new output_space_size: 5,
                   epochs: 1

 ## Randomly fill the output space
(25).times{ som.output_space.add(SOM::Neuron.new(@bin_matrix.bin_matrix.first.size){ rand 0..1 }) }

som.input_patterns = @bin_matrix
som.exec!
som.create_umatrix

puts "Generating Report...."
som.report( report_neuron_text: true )

binding.pry

