using VectorizedRoutines
using Test

# MATLAB

@test size(Matlab.meshgrid(0:0.1:1),1) == 2
@test size(Matlab.meshgrid(0:0.1:1)[1]) == (11,11)
@test Matlab.meshgrid(0:0.1:1) == Matlab.meshgrid(0:0.1:1,0:0.1:1)
@test size(Matlab.meshgrid(0:0.1:1,0:0.1:1,0:0.1:1)[1]) == (11,11,11)

# R

v1=1:5
v2 = 5:-1:1
@test R.rep(v1,v2) == [1;1;1;1;1;2;2;2;2;3;3;3;4;4;5]

xs = collect(1:26)
Xs = multireshape(xs, (2,3), (4,5)) # Array of two matrices, 2×3 and 4×5
# Now, the elements of xs and Xs reference the same memory, no copying.
xs[26] = 42
@test Xs[2][4,5] == 42
Xs[2][3,5] = 100
@test xs[25] == 100 # 100

# pairwise
xs = 1:26
func(x,y) = sqrt(x^2 + y^2)

using Statistics, LinearAlgebra
@test isapprox(mean(pairwise(func, xs)), 20.542901932949146)
@test pairwise(func, xs, Symmetric) == Symmetric(pairwise(func, xs))

:($(Expr(:let, quote
    res = Int[]
    for i = 1:10
        if i % 2 == 0
            push!(res, i ^ 2)
        end
    end
    res
end)))
