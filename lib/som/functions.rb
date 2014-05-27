module SOM
  module Functions
    def exponential_decay  n0, lamb, current_step
      (Float(n0) * Math::exp((-Float(current_step))/Float(lamb)))
    end
    def lamb x,y
      Float(x)/(Math::log(y))
    end
  end
end
