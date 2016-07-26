"""
From Images.jl
"""
@generated function findlocalextrema{T,N}(img::AbstractArray{T,N}, region::Union{Tuple{Int},Vector{Int},UnitRange{Int},Int}, edges::Bool, order::Base.Order.Ordering)
    quote
        issubset(region,1:ndims(img)) || throw(ArgumentError("Invalid region."))
        extrema = Tuple{(@ntuple $N d->Int)...}[]
        @inbounds @nloops $N i d->((1+!edges):(size(img,d)-!edges)) begin
            isextrema = true
            img_I = (@nref $N img i)
            @nloops $N j d->(in(d,region) ? (max(1,i_d-1):min(size(img,d),i_d+1)) : i_d) begin
                (@nall $N d->(j_d == i_d)) && continue
                if !Base.Order.lt(order, (@nref $N img j), img_I)
                    isextrema = false
                    break
                end
            end
            isextrema && push!(extrema, (@ntuple $N d->(i_d)))
        end
        extrema
    end
end

"""
`findlocalmaxima(img, [region, edges]) -> Vector{Tuple}`
Returns the coordinates of elements whose value is larger than all of their
immediate neighbors.  `region` is a list of dimensions to consider.  `edges`
is a boolean specifying whether to include the first and last elements of
each dimension.

From Images.jl
"""
findlocalmaxima(img::AbstractArray, region=coords_spatial(img), edges=true) =
        findlocalextrema(img, region, edges, Base.Order.Forward)

"""
Like `findlocalmaxima`, but returns the coordinates of the smallest elements.

From Images.jl
"""
findlocalminima(img::AbstractArray, region=coords_spatial(img), edges=true) =
        findlocalextrema(img, region, edges, Base.Order.Reverse)
