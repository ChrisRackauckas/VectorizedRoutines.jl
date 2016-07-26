module Julia

if VERSION >= v"0.5-"
    @doc """
`multireshape(A, dims1, dims2[, ...])`

Create a vector of reshaped views of `A`, referencing the same data.

    julia> xs = zeros(126);
    julia> Xs = multireshape(xs, (2,3), (4,5,6));
    julia> # `Xs` is a vector of multidimensional arrays (one 2×3 matrix and 4×5×6 tensor).
    julia> # Now, the elements of xs and Xs reference the same memory, no copying.
    julia> xs[5] = 1;
    julia> Xs[1][1,3]
    1
    julia> Xs[2][4,5,6] = 100;
    julia> xs[126]
    2
""" -> function multireshape end
else
    @doc """
`multireshape(A, dims1, dims2[, ...])`

Create a vector of reshaped views of `A`, copying the original data.
Use Julia 0.5 to avoid copying, i.e. the result of multireshape references the same data.
""" -> function multireshape end
end

function multireshape(parent::AbstractArray, dimss::Tuple{Vararg{Int}}...)
    n = length(parent)
    sum(map(prod, dimss)) == n || throw(DimensionMismatch("parent has $n elements, which is incompatible with size $dimss"))
    arrays = Vector(length(dimss))
    indexcurr = 0
    for i in 1:length(dimss)
        indexprev = indexcurr
        indexcurr = indexprev + prod(dimss[i])
        if VERSION < v"0.5-"
            arrays[i] = reshape(sub(parent, (indexprev+1):indexcurr), dimss[i])
        else
            arrays[i] = reshape(view(parent, (indexprev+1):indexcurr), dimss[i])
        end
    end
    arrays
end

# Allow dimensions to be passed as array.
function multireshape(parent::AbstractArray, dimss::Array{Tuple{Vararg{Int}}})
    multireshape(parent, dimss...)
end

end
