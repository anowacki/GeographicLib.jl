# Displaying custom types

const SHOW_MAXLEN = maximum(length,
    [fieldnames.((Geodesic, Result))...])

function Base.show(io::IO, x::Union{Geodesic, Result})
    println(io, typeof(x), ":")
    for f in fieldnames(typeof(x))
        v = getfield(x, f)
        println(io, lpad(String(f), SHOW_MAXLEN), ": ", v === nothing ? "<>" : v)
    end
end
