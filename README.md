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

# Using the Package

The functions from R/Python/MATLAB are implemented in order to match the functionality
of their appropriate packages. In order to not have namespace issues, they are
contained in appropriate modules, so you would call the MATLAB functions like:

```julia
mgrid = MATLAB.meshgrid(0:1//4:1,0:1//8:1)
```

and the R functions like:

```julia
v1=1:5
v2 = 5:-1:1
repped = R.rep(v1,v2)
```

Although these look like they are calling some outside package from these languages,
they are bonafide Julia implementations and thus can handle Julia specific issues
(like using Rational numbers in the meshgrid).

# Current Functions

- MATLAB
  - ngrid
  - meshgrid
  - accumarray (fast)
  - accumarray2 (more functionality)
- R
  - rep
  - findinterval
  - rpois ([fast on vectors](http://codereview.stackexchange.com/questions/134926/benchmarks-of-scientific-programming-languages-r-julia-mathematica-matlab-f/135220#135220))
