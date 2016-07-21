module R

  using Distributions, StatsFuns

  """
  rep(x,each)

  Originally due to RLEVectors.jl
  """
  function rep{T1,T2}(x::AbstractVector{T1},each::AbstractVector{T2} = ones(Int,length(x)), times::Int = 1)
    length(x) != length(each) && throw(ArgumentError("If the argument 'each' is not a scalar, it must have the same length as 'x'."))
    length_out = sum(each * times)
    rval = similar(x,length_out)
    index = 0
    for i in 1:times
      for j in eachindex(x)
        @inbounds @simd for k in 1:each[j]
          index += 1
          @inbounds rval[index] = x[j]
        end
      end
    end
    return(rval)
  end

  function rep!{T1,T2}(x::AbstractVector{T1},rval::AbstractVector{T1},each::AbstractVector{T2} = ones(Int,length(x)))
    length_old = length(x)
    length_old != length(each) && throw(ArgumentError("If the argument 'each' is not a scalar, it must have the same length as 'x'."))
    length_out = sum(each) #times =  1
    index = length_out
    resize!(rval,length_out)
    resize!(x,length_out)
    for j in length_old:-1:1
      @inbounds @simd for k in 1:each[j]
        @inbounds rval[index] = x[j]
        index -= 1
      end
    end
    x[1:length_out] = rval[1:length_out]
    return(length_out)
  end

  rep(x::Any,each::Int=1,times::Int = 1) = rep(x,each = [ each for i in eachindex(x) ],times=times)
  rep{T2}(x::Any,each::AbstractVector{T2}=[1],times::Int = 1) = rep([x],each=each,times=times)

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
      @inbounds out[i] = StatsFuns.RFunctions.poisrand(p[i]) #rand(Poisson(p[i])) #
    end
    out
  end

  function rpois!(n::Int,p::Vector{Float64},out::Vector{Int})
    resize!(out,n)
    for i in 1:n
      @inbounds out[i] = StatsFuns.RFunctions.poisrand(p[i]) #rand(Poisson(p[i])) #
    end
  end
end
