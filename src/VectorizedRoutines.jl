__precompile__()

module VectorizedRoutines

include("internal.jl") #For Julia functions to wrap but reduce imports
include("matlab.jl")
include("python.jl")
include("r.jl")
include("julia.jl")

export R, Matlab, Julia, Python

end # module
