module Julia

"""
`multireshape(A, dims1, dims2[, ...])`

Create a vector of reshaped views of `A`.

    julia> xs = collect(1:126);
    julia> Xs = multireshape(xs, (2,3), (4,5,6));
    julia> # `Xs` is a vector of multidimensional arrays (one 2×3 matrix and 4×5×6 tensor).
    julia> # Now, the elements of xs and Xs reference the same memory, no copying.
    julia> xs[5] = 42;
    julia> Xs[1][1,3]
    42
    julia> Xs[2][4,5,6] = 100;
    julia> xs[126]
    100
"""
function multireshape(parent::AbstractArray, dimss::Tuple{Vararg{Int}}...)
    n = length(parent)
    sum(map(prod, dimss)) == n || throw(DimensionMismatch("parent has $n elements, which is incompatible with size $dimss"))
    arrays = Vector(length(dimss))
    indexcurr = 0
    for i in 1:length(dimss)
        indexprev = indexcurr
        indexcurr = indexprev + prod(dimss[i])
        arrays[i] = reshape(view(parent, (indexprev+1):indexcurr), dimss[i])
    end
    arrays
end
# Allow dimensions to be passed as array or tuple.
function multireshape(parent::AbstractArray, dimss::Array{Tuple{Vararg{Int}}})
    multireshape(parent, dimss...)
end
function multireshape(parent::AbstractArray, dimss::Tuple{Vararg{Tuple{Vararg{Int}}}})
    multireshape(parent, dimss...)
end

end
