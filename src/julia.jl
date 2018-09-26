
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
    arrays = Vector(undef,length(dimss))
    indexcurr = 0
    for i in 1:length(dimss)
        indexprev = indexcurr
        indexcurr = indexprev + prod(dimss[i])
        arrays[i] = reshape(view(parent, (indexprev+1):indexcurr), dimss[i])
    end
    arrays
end

# Allow dimensions to be passed as array.
function multireshape(parent::AbstractArray, dimss::Array{Tuple{Vararg{Int}}})
    multireshape(parent, dimss...)
end

"""
    pairwise(f::Function, a[, ::Type{Symmetric}])

Apply the function `f` to all pairwise combinations of elements from `a`. Pass
`Symmetric` to only calculate `f(x,y)` when `f(x,y) == f(y,x)` and return a
`Symmetric Matrix`.
"""
function pairwise(f::Function, a)
    n = length(a)
    n == 0 && return Matrix{Core.Inference.return_type(f, NTuple{2,eltype(a)})}(undef,0, 0)
    firstval = f(first(a), first(a))
    r = Matrix{typeof(firstval)}(undef,n, n)
    pairwise_internal!(f, a, r, firstval, n)
    r
end


function pairwise(f::Function, a, ::Type{Symmetric})
    n = length(a)
    n == 0 && return Matrix{Core.Inference.return_type(f, NTuple{2,eltype(a)})}(undef,0, 0)
    firstval = f(first(a), first(a))
    r = Symmetric(Matrix{typeof(firstval)}(undef,n, n))
    pairwise_internal!(f, a, r, firstval, n)
    r
end

"""
    pairwise!(f::Function, a, r)

Apply the function `f` to all pairwise combinations of elements from `a` and
storing the results in `r`. If `r` is a `Symmetric` the function will only
calculate each variable combination once, which is useful if `f` is expensive
and `f(x,y) == f(y,x)`.
"""
function pairwise!(f::Function, a, r::AbstractMatrix)
    n = length(a)
    size(r) == (n, n) || throw(DimensionMismatch("Incorrect size of r ($(size(r)), should be $((n, n)))"))
    n == 0 || pairwise_internal!(f, a, r, f(first(a), first(a)),n)
end

function pairwise_internal!(f, a, r::AbstractMatrix{T}, firstval::T, n) where {T}
    r[1,1] = firstval
    i, j = 2, 1
    @inbounds  while j ≤ n
        aj = a[j]
         while i ≤ n
            r[i,j] = f(a[i], aj)
            i += 1
        end
        j += 1
        i = 1
    end
end

function pairwise_internal!(f, a, r::Symmetric{T}, firstval::T, n) where {T}
    r.uplo == 'U' ? pairwise_symmetric_U!(f, a, r, firstval, n) : pairwise_symmetric_L!(f, a, r, firstval, n)
end

function pairwise_symmetric_L!(f, a, r::Symmetric, firstval, n)
    r.data[1,1] = firstval
    i, j = 2, 1
    @inbounds while j ≤ n
        aj = a[j]
        while i <= n
            r.data[i,j] = f(a[i], aj)
            i += 1
        end
        j += 1
        i = j
    end
end

function pairwise_symmetric_U!(f, a, r::Symmetric, firstval, n)
    r.data[1,1] = firstval
    i, j = 1, 2
    @inbounds while j ≤ n
        aj = a[j]
        while i ≤ j
            r.data[i,j] = f(a[i], aj)
            i += 1
        end
        j += 1
        i = 1
    end
end
