module Julia
    export multireshape, pairwise, pairwise!
"""
`multireshape(A, dims1, dims2[, ...])`

Create a vector of reshaped views of `A` with given dimensions.
The reshaped views reference the original data, there is no copying.
In Julia versions prior to 0.5, the data _is_ copied.

    julia> xs = rand(126);
    julia> Xs = multireshape(xs, (2,3), (4,5,6));
    julia> # `Xs` is a vector of multidimensional arrays (one 2×3 matrix and 4×5×6 tensor).
"""
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

"""
    pairwise(f::Function, a[, ::Type{Symmetric}])

Apply the function `f` to all pairwise combinations of elements from `a`. PassPro
`Symmetric` to only calculate `f(x,y)` when `f(x,y) == f(y,x)` and return a
`Symmetric Matrix`.
"""
function pairwise(f::Function, a)
    n = length(a)
    firstval = f(first(a), first(a))
    r = Matrix{typeof(firstval)}(n, n)
    pairwise!(f, a, r)
    r
end


function pairwise(f::Function, a, ::Type{Symmetric})
    n = length(a)
    firstval = f(first(a), first(a))
    r = Symmetric(Matrix{typeof(firstval)}(n, n))
    pairwise!(f, a, r)
    r
end

"""
    pairwise!(f::Function, a, r)

Apply the function `f` to all pairwise combinations of elements from `a` and
storing the results in `r`. Setting keyword `symmetric = true` will only calculate
each variable combination once for symmetric functions. This is useful if `f` is
expensive.
"""
function pairwise!(f::Function, a, r::AbstractMatrix)
    n = length(a)
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r ($(size(r)), should be $((n, n)))"))
    pairwise_internal!(f, a, r)
end

function pairwise_internal!(f, a, r::AbstractMatrix)
    @inbounds for j in eachindex(a)
        aj = a[j]
        for i in eachindex(a)
            r[i,j] = f(a[i], aj)
        end
    end
end

function pairwise_internal!(f, a, r::Symmetric)
    r.uplo == 'U' ? pairwise_symmetric_U!(f, a, r) : pairwise_symmetric_L!(f, a, r)
end

function pairwise_symmetric_L!(f, a, r::Symmetric)
    @inbounds for j in eachindex(a)
        aj = a[j]
        i = j
        while i <= endof(a)
            r.data[i,j] = f(a[i], aj)
            i = nextind(a, i)
        end
    end
end

function pairwise_symmetric_U!(f, a, r::Symmetric)
    @inbounds for j in eachindex(a)
        aj = a[j]
        i = start(a)
        while i <= j
            r.data[i,j] = f(a[i], aj)
            i = nextind(a, i)
        end
    end
end

end
