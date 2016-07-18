module R

  using Distributions
  
  """
  rep(x,each)

  Originally due to RLEVectors.jl
  """
  function rep{T1,T2}(x::Union{Any,AbstractVector{T1}}; each::Union{Int,AbstractVector{T2}} = ones(Int,length(x)), times::Int = 1)
    if !(typeof(x) <: AbstractVector)
      x = [ x ]
    end
    if (typeof(each) <: Int)
      each = [ each for i in eachindex(x) ]
    end
    length(x) != length(each) && throw(ArgumentError("If the arguemnt 'each' is not a scalar, it must have the same length as 'x'."))
    length_out = sum(each * times)
    rval = similar(x,length_out)
    index = 0
    for i in 1:times
      for j in eachindex(x)
        @inbounds for k in 1:each[j]
          index += 1
          @inbounds rval[index] = x[j]
        end
      end
    end
    return(rval)
  end

  """
  findinterval(v,x)

  Originally due to RLEVectors.jl
  """
  function findinterval(v::AbstractVector, x::AbstractVector, lo::Int, hi::Int)
      indices = similar(x)
      min = lo - 1
      max = hi + 1
      @inbounds for (i,query) in enumerate(x)
          hi = hi + 1 # 2X speedup with this *inside* the loop for sorted x
          # unsorted x, restart left side
          if lo <= min || query <= v[lo]
              lo = min
          end
          if hi >= max || query >= v[hi]
              hi = max
          end
          # binary search for the exact bin
          while hi - lo > 1
              m = (lo+hi)>>>1
              if query > v[m]
                  lo = m
              else
                  hi = m
              end
          end
          indices[i] = hi
      end
      return(indices)
  end
  findinterval(v::AbstractVector, x::AbstractVector) = findinterval(v, x, 1, length(v))

  """
  rpois()
  """
  function rpois(n::Int,p::Vector{Float64})
    out = Vector{Int}(n)
    for i in 1:n
      @inbounds out[i] = rand(Poisson(p[i]))
    end
    out
  end
end
