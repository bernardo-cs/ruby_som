# Ruby SOM

![IST Logo](http://tecnico.ulisboa.pt/img/tecnico.png)

A pure ruby library for Self Organizing Maps, if you want to know more about this kind of neural network, feel free to checkout Fernando Bação and Victor Lobo [Introduction to SOMs]( http://edugi.uji.es/Bacao/SOM%20Tutorial.pdf ) if you are more into knowing how to program SOMs check out this [tutorial]( http://davis.wpi.edu/~matt/courses/soms/ ) by Tom Germano.


### Solving Fernando Bação SOM exercise

~~~ruby
som = SOM::SOM.new learning_rate: 0.6, force_radius: 1, epochs: 1
som.input_patterns = SOM::Matrix.new([[1,1,0,0],[0,0,0,1],[1,0,0,0],[0,0,1,1]])
[ SOM::Neuron.new( [0.2,0.6,0.5,0.9] ),
  SOM::Neuron.new( [0.8,0.4,0.7,0.3] )].each{ |n| som.output_space.add n }

som.exec! do |som_state, i|
  puts "iteration: #{i} radius: #{som_state.radius}, learning_rate: #{som_state.learning_rate}"
end
puts som.to_s
~~~

### Training the neural network ( map ) to identify colours

~~~ruby
som = SOM::SOM.new output_space_size: 15,
                   epochs: 1500

## Randomly fill the output space
(225).times{ som.output_space.add(SOM::Neuron.new(3){ rand 0..255 }) }

## Generate 1500 random input patterns
som.input_patterns = 1500.times.inject([]){ |arr| arr << Array.new(3){ rand(0..255) }; arr  }

som.exec_and_print_steps!('test_folder')
~~~

For more examples, checkout the bin folder, or the spec folder for tests.

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT).