__precompile__()

module VectorizedRoutines

include("matlab.jl")
include("r.jl")

include("julia.jl")

export R, Matlab, Julia

end # module
