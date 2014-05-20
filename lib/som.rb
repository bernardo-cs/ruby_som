module SOM
  require_relative 'som/printable'
  require_relative 'som/neuron'
  require_relative 'som/output_space'
  require_relative 'som/input_pattern'
  require_relative 'som/som'
  require_relative 'som/umatrix'

  def example
    o = SOM.new
  end
end


include SOM
