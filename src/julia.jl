module Julia

  """
  `multireshape(A, dims1, dims2[, ...])`

  Create a vector of arrays with the same data as the given array, but with different dimensions.
  """
  function multireshape(parent::AbstractArray, dims1::Dims, dims2::Dims, dimss::Tuple{Dims}...)
      dimss = tuple(dims1, dims2, dimss...)
      n = length(parent)
      sum(map(prod, dimss)) == n || throw(DimensionMismatch("parent has $n elements, which is incompatible with size $dimss"))
      arrays = Vector(length(dimss))
      indexcurr = 0
      for i in 1:length(dimss)
          indexprev = indexcurr
          indexcurr = indexprev + prod(dimss[i])
          indices = (indexprev+1):indexcurr
          flatsubarray = view(parent, indices)
          arrays[i] = reshape(flatsubarray, dimss[i])
      end
      arrays
  end
end
