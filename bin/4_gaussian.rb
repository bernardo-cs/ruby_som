include Math

def gaussian arr1, arr2
  E**(-6.66667*dist(arr1, arr2))
end

def dist ar1, ar2
  sqrt(ar1**2 + ar2**2)
end

def euclidian ar1, ar2
  sqrt(ar1.zip(ar2).map{ |x| x.reduce(:-) }.map{|x| x**2}.reduce(:+))
end
