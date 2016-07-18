using VectorizedRoutines
using Base.Test

# write your own tests here
@test 1 == 1

v1=1:5
v2 = 5:-1:1
R.rep(v1,each = v2) == [1;1;1;1;1;2;2;2;2;3;3;3;4;4;5]
