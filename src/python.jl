module Python

"""
    @vcomp(comprehension::Expr, when::Symbol, condition)

`@vcomp` (*vector comprehension*) based on Python's list comprehensions
with a conditional clause to filter elements in a succinct way.

# Examples
```julia
julia> @vcomp Int[i^2 for i in 1:10] when i % 2 == 0
5-element Array{Int,1}:
   4
  16
  36
  64
 100

julia> words = ["ant", "akita", "bear", "cow"];

julia> @vcomp [uppercase(word) for word in words] when startswith(word, "a")
2-element Array{Any,1}:
 "ANT"
 "AKITA"

julia> @vcomp Tuple[(i, e) for (i, e) in enumerate(reverse(1:10))] when i-e < 0
5-element Array{Tuple,1}:
 (1,10)
 (2,9)
 (3,8)
 (4,7)
 (5,6)
```
"""
macro vcomp(comprehension::Expr, when::Symbol, condition)
    comp_head, comp_args = comprehension.head, comprehension.args
    comp_head ∉ [:comprehension, :typed_comprehension] && error("@vcomp not a comprehension")
    when ≠ :when && error("@vcomp expected `when`, got: `$when`")
    T = comp_head == :typed_comprehension ? comp_args[1] : nothing
    if VERSION < v"0.5-"
        element  = comp_head == :comprehension ? comp_args[1] : comp_args[2]
        sequence = comp_head == :comprehension ? comp_args[2] : comp_args[3]
    else
        element  = comp_head == :comprehension ? comp_args[1].args[1] : comp_args[2].args[1]
        sequence = comp_head == :comprehension ? comp_args[1].args[2] : comp_args[2].args[2]
    end    
    result = T ≠ nothing ? :($T[]) : :([])
    loop = Expr(:for, sequence,
               Expr(:block,
                   Expr(:if, condition,
                       Expr(:block,
                           Expr(:call, :push!, :res, element)))))
    block = Expr(:let,
                Expr(:block,
                    Expr(:(=), :res, result), loop, :res))
    return esc(block)
end

end
