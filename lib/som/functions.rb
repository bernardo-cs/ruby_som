module SOM
  module Functions
    def exponential_decay  n0, lamb, current_step
      (Float(n0) * Math::exp((-Float(current_step))/Float(lamb)))
    end
    def lamb x,y
      Float(x)/(Math::log(y))
    end
    def influence dist, max_dist
      1.0 - (Float(dist)/Float(max_dist + 1))
      #Math::exp( (( dist**2 ) / (2.0 * (max_dist**2))) )
    end
  end
end
