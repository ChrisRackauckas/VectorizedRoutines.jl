__precompile__()

module VectorizedRoutines

include("matlab.jl")
include("python.jl")
include("r.jl")
include("julia.jl")

export R, Matlab, Julia, Python

end # module
