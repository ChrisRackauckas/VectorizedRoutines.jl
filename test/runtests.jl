using VectorizedRoutines
using Base.Test

# MATLAB

@test size(Matlab.meshgrid(0:0.1:1),1) == 2
@test size(Matlab.meshgrid(0:0.1:1)[1]) == (11,11)
@test Matlab.meshgrid(0:0.1:1) ==Matlab.meshgrid(0:0.1:1,0:0.1:1)
@test size(Matlab.meshgrid(0:0.1:1,0:0.1:1,0:0.1:1)[1]) == (11,11,11)

# R

v1=1:5
v2 = 5:-1:1
@test R.rep(v1,v2) == [1;1;1;1;1;2;2;2;2;3;3;3;4;4;5]

# Python

@test (Python.@vcomp Int[i^2 for i in 1:10] when i % 2 == 0) == Int[4, 16, 36, 64, 100]
words = ["ant", "akita", "bear", "cow"]
@test (Python.@vcomp [uppercase(word) for word in words] when startswith(word, "a")) == Any["ANT", "AKITA"]
@test (Python.@vcomp Tuple[(i, e) for (i, e) in enumerate(reverse(1:10))] when i-e < 0) == Tuple[(1,10),(2,9),(3,8),(4,7),(5,6)]
ß
# Julia

xs = collect(1:26)
Xs = Julia.multireshape(xs, (2,3), (4,5)) # Array of two matrices, 2×3 and 4×5
# Now, the elements of xs and Xs reference the same memory, no copying.
xs[26] = 42
@test Xs[2][4,5] == 42
Xs[2][3,5] = 100
@test xs[25] == 100 # 100

# pairwise
xs = 1:26
func(x,y) = sqrt(x^2 + y^2)
@test isapprox(mean(Julia.pairwise(func, xs)), 20.542901932949146)
@test isapprox(mean(Julia.pairwise(func, xs, :vec, ondiag = false)), 20.60094268658563) #ignoring the diagonal makes the difference
@test mean(Julia.pairwise(prod, xs)) == 182.25 # using a vectorized function instead
