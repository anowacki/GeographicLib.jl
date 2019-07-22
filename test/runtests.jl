using Test
using GeographicLib
import PyCall

@testset "All tests" begin
    include("maths.jl")
    include("geodesics.jl")
    include("geodesiclines.jl")
    include("direct.jl")
    include("geographiclib.jl")
end