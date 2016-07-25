using VectorizedRoutines
using Base.Test

# write your own tests here
@test 1 == 1

v1=1:5
v2 = 5:-1:1
@test R.rep(v1,v2) == [1;1;1;1;1;2;2;2;2;3;3;3;4;4;5]

xs = collect(1:26)
Xs = Julia.multireshape(xs, (2,3), (4,5)) # Array of two matrices, 2×3 and 4×5
# Now, the elements of xs and Xs reference the same memory, no copying.
xs[26] = 42
@test Xs[2][4,5] == 42
Xs[2][3,5] = 100
@test xs[25] == 100 # 100
