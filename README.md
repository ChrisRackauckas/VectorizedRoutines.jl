# VectorizedRoutines.jl

[![Build Status](https://travis-ci.org/ChrisRackauckas/VectorizedRoutines.jl.svg?branch=master)](https://travis-ci.org/ChrisRackauckas/VectorizedRoutines.jl) [![Build status](https://ci.appveyor.com/api/projects/status/if9fipfemtdyg49p?svg=true)](https://ci.appveyor.com/project/ChrisRackauckas/vectorizedroutines-jl)

VectorizedRoutines.jl provides a library of familiar and useful vectorized routines. This package hopes to include high-performance, tested, and documented  Julia implementations  of routines which MATLAB/Python/R users would be familiar with. We also welcome generally useful routines for operating on vectors/arrays.

# Installation


To install the package, simply use:

```julia
Pkg.add("VectorizedRoutines")
using VectorizedRoutines
```

For the latest features, switch to the master branch via:

```julia
Pkg.checkout("VectorizedRoutines")
```

# Using the Package

The functions from R/Python/MATLAB are implemented in order to match the functionality
of their appropriate packages. In order to not have namespace issues, they are
contained in appropriate modules, so you would call the MATLAB functions like:

```julia
mgrid = Matlab.meshgrid(0:1//4:1,0:1//8:1)
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

If you want to export the functions to the main namespace, simply use the commands like this:

```julia
using VectorizedRoutines.R
rpois(1,[5.2;3.3]) # Same as R.rpois(1,[5.2;3.3])

```
The original Julia vectorized routines offered here do not need to be prefaced:

```julia
xs = 1:26
pairwise((x,y)->sqrt(x^2 + y^2), xs)
```

# Current Functions and Macros

- MATLAB
  - `ngrid`
  - `meshgrid`
  - `accumarray` (fast)
  - `accumarray2` (more functionality)
  - Compatibility Functions:
    - `disp`
    - `strcat`
    - `num2str`
    - `max`
    - `numel`
- Python
  - `@vcomp` (*vector comprehension*) macro based on Python's list comprehensions
with a conditional clause to filter elements in a succinct way, ie: `@vcomp Int[i^2 for i in 1:10] when i % 2 == 0    # Int[4, 16, 36, 64, 100]`

- R
  - `rep`
  - `rep!`
  - `findinterval`
  - `rpois` ([fast on vectors](http://codereview.stackexchange.com/questions/134926/benchmarks-of-scientific-programming-languages-r-julia-mathematica-matlab-f/135220#135220))
  - `rpois!`

- The package also offers Julia-native vectorized routines that are not found in MATLAB, Python or R.
  - `multireshape` (a reshape which can produce views to multiple arrays)
  - `pairwise` (apply a function to all pairwise combinations of elements from an array)
  - `pairwise!`
