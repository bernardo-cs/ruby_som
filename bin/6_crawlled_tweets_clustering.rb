require_relative "../../mini_twitter/lib/social_network.rb"
require_relative "../../dataset_mapper/lib/dataset_mapper"
require_relative "../../data_parser/lib/data_parser/bin_matrix.rb"
require_relative "../../som/lib/som"

social_network = MiniTwitter::SocialNetwork.new
social_network = social_network.unmarshal_latest!

puts 'Social Network in Usage Info', social_network.to_s

@csv_matrix_file = Tempfile.new('csv_matrix')
@bin_matrix = BinMatrix.new( @csv_matrix_file.path, social_network.all_tweets_trimmed_text.sample( 5000 ), 0)

som = SOM::SOM.new output_space_size: 5

 ## Randomly fill the output space
(25).times{ som.output_space.add(SOM::Neuron.new(@bin_matrix.bin_matrix.first.size){ rand 0..1 }) }

som.input_patterns = @bin_matrix
som.exec!
som.create_umatrix

puts "Generating Report...."
som.report( report_neuron_text: true )
