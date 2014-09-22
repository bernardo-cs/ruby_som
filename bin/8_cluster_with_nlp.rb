require_relative "../../mini_twitter/lib/social_network.rb"
require_relative "../../dataset_mapper/lib/dataset_mapper"
require_relative "../../data_parser/lib/data_parser/tweets_bin_matrix.rb"
require_relative "../../data_parser/lib/data_parser/string.rb"
require_relative "../../som/lib/som"

gem 'ark_tweet_nlp'

social_network = MiniTwitter::SocialNetwork.new
social_network = social_network.unmarshal_latest!

puts 'Social Network in Usage Info', social_network.to_s

## Save tweets text state
tweets_trimmed_text = social_network.all_tweets_trimmed_text
tweets_text = social_network.all_tweets_text

## Find all words in the crawwled tweets that ar of type:
#  N, ^, #, U = > Common noun, proper noun, hashtags, url or email
tagged_result = ArkTweetNlp::Parser.find_tags( tweets_text.inject(""){ |acum,t| acum + t.gsub("\n",'').gsub("\t", " ") + "\n"}[0..-2] )
wanted_words  = ArkTweetNlp::Parser.get_words_tagged_as( tagged_result, :N, :^, :"#")
res = Set.new
wanted_words.each do |k,v|
  puts "Word type: " + ArkTweetNlp::Parser::TAGSET[k]
  puts "found: " + v.size.to_s + " words"
  puts "where: " + Set.new( v ).size.to_s + " are unique"
  trimmed_and_unique = Set.new( Set.new( v ).map{ |l| l.trim }.reject{ |n| n.nil? || n == "" })
  puts "when trimed: " + trimmed_and_unique.size.to_s  + " are unique"
  res.merge trimmed_and_unique
end

## Merging all the trimmed results will lead to ~= 30% reduction in the SVM size
puts "All unique: " + res.size.to_s

@bin_matrix = DataParser::TweetsBinMatrix.new( social_network.all_tweets,  res )

som = SOM::SOM.new output_space_size: 10, epochs: 500

## Randomly fill the output space
(100).times{ som.output_space.add(SOM::Neuron.new(@bin_matrix.svm.first.size){ rand 0..1 }) }

## Only add input patterns that contain at least one position
som.input_patterns = @bin_matrix.select{ |i| i.reduce(:+) > 0 }
som.exec!
som.create_umatrix

puts "Generating Report...."
som.report( report_neuron_text: false )

