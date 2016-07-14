# VectorizedRoutines.jl

[![Build Status](https://travis-ci.org/ChrisRackauckas/VectorizedRoutines.jl.svg?branch=master)](https://travis-ci.org/ChrisRackauckas/VectorizedRoutines.jl) [![Build status](https://ci.appveyor.com/api/projects/status/if9fipfemtdyg49p?svg=true)](https://ci.appveyor.com/project/ChrisRackauckas/vectorizedroutines-jl)

VectorizedRoutines.jl provides a library of familiar and useful vectorized routines. This package hopes to include high-performance, tested, and documented  Julia implementations  of routines which MATLAB/Python/R users would be familiar with. We also welcome generally useful routines for operating on vectors.

# Installation

Since the package is currently unregistered, you can install the package by cloning the repository:

```julia
Pkg.clone("https://github.com/ChrisRackauckas/VectorizedRoutines.jl")
```

To use the package, simply call

```julia
using VectorizedRoutines
```

# Current Functions

- MATLAB
  - ngrid
  - meshgrid
  - accumarray (fast)
  - accumarray2 (more functionality)
