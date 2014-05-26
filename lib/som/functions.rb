module SOM
  module Functions
    def exponential_decay  initial_value, temporal_const, iteration
      (initial_value * Math::exp((-iteration)/temporal_const))
    end
  end
end
