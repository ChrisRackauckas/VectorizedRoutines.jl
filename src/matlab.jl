module Matlab

  export ndgrid, meshgrid, accumarray, accumarray2, disp, num2str, strcat, numel, findpeaks
  # No max becuase... issues

  ndgrid(v::AbstractVector) = copy(v)

  function ndgrid(v1::AbstractVector{T}, v2::AbstractVector{T}) where {T}
      m, n = length(v1), length(v2)
      v1 = reshape(v1, m, 1)
      v2 = reshape(v2, 1, n)
      (repeat(v1, 1, n), repeat(v2, m, 1))
  end

  function ndgrid_fill(a, v, s, snext)
      for j = 1:length(a)
          a[j] = v[div(rem(j-1, snext), s)+1]
      end
  end

  function ndgrid(vs::AbstractVector{T}...) where {T}
      n = length(vs)
      sz = map(length, vs)
      out = ntuple(i->Array{T}(sz), n)
      s = 1
      for i=1:n
          a = out[i]::Array
          v = vs[i]
          snext = s*size(a,i)
          ndgrid_fill(a, v, s, snext)
          s = snext
      end
      out
  end

  """
  meshgrid(vx)

  Computes an (x,y)-grid from the vectors (vx,vx).
  For more information, see the MATLAB documentation.
  """
  meshgrid(v::AbstractVector) = meshgrid(v, v)

  """
  meshgrid(vx,vy)

  Computes an (x,y)-grid from the vectors (vx,vy).
  For more information, see the MATLAB documentation.
  """
  function meshgrid(vx::AbstractVector{T}, vy::AbstractVector{T}) where {T}
      m, n = length(vy), length(vx)
      vx = reshape(vx, 1, n)
      vy = reshape(vy, m, 1)
      (repeat(vx, m, 1), repeat(vy, 1, n))
  end

  """
  meshgrid(vx,vy,vz)

  Computes an (x,y,z)-grid from the vectors (vx,vy,vz).
  For more information, see the MATLAB documentation.
  """
  function meshgrid(vx::AbstractVector{T}, vy::AbstractVector{T},
                       vz::AbstractVector{T}) where {T}
      m, n, o = length(vy), length(vx), length(vz)
      vx = reshape(vx, 1, n, 1)
      vy = reshape(vy, m, 1, 1)
      vz = reshape(vz, 1, 1, o)
      om = ones(Int, m)
      on = ones(Int, n)
      oo = ones(Int, o)
      (vx[om, :, oo], vy[:, on, oo], vz[om, on, :])
  end

  """
  accumarray(subs, val, sz=(maximum(subs),))

  See MATLAB's documentation for more details.
  """
  function accumarray(subs, val, sz=(maximum(subs),))
      A = zeros(eltype(val), sz...)
      for i = 1:length(val)
          @inbounds A[subs[i]] += val[i]
      end
      A
  end

  function accumarray(subs, val::Number, sz=(maximum(subs),))
      A = zeros(eltype(val), sz...)
      for i = 1:length(subs)
          @inbounds A[subs[i]] += val[i]
      end
      A
  end

  """
  Slower than accumarray but more functionality
  """
  function accumarray2(subs, val, fun=sum, fillval=0; sz=maximum(subs,1), issparse=false)
     counts = Dict()
     for i = 1:size(subs,1)
          counts[subs[i,:]]=[get(counts,subs[i,:],[]);val[i...]]
     end
     A = fillval*ones(sz...)
     for j = keys(counts)
          A[j...] = fun(counts[j])
     end
     issparse ? sparse(A) : A
  end

  """
  Originally from MATLABCompat.jl
  """
  function disp(string)
    println(string)
    return true
  end

  #
  """
  Covert number to a string in a MATLAB style
  Originally from MATLABCompat.jl
  """
  function num2str(number)
    string = "$number"
    return string
  end

  """
  Wrapper for the Julia function string for compatibility with MATLAB syntax
  Originally from MATLABCompat.jl
  """
  function strcat(stringsToAdd...)
    concatenatedString = ""
    for i in 1:length(stringsToAdd)
      concatenatedString = string(concatenatedString, stringsToAdd[i])
    end
    return concatenatedString
  end

  """
  Wrapper for the numel function
  Originally from MATLABCompat.jl
  """
  function numel(matrix)
    numberOfElements = length(matrix)
    return numberOfElements
  end

  """
  Wrapper for the max function
  Originally from MATLABCompat.jl
  """
  function max(vector)
    maxOfVector = maximum(vector)
    return maxOfVector
  end

  function findpeaks(img::AbstractArray, region=coords_spatial(img), edges=true)
    idxs = findlocalmaxima(img, region=region, edges=edges)
    return imgs[idxs],idxs
  end

end
