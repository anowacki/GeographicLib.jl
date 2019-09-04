# Struct holding results of the GeographicLib interface

"""
    Result

Type holding the result of a forward or inverse calculation using a geodesic.

If fields have not been calculated because of the presence/absence of any
flags when performing the calculation, the field will be `nothing`.
"""
mutable struct Result
    "Latitude of starting point (°)"
    lat1::Union{Float64,Nothing}
    "Longitude of starting point (°)"
    lon1::Union{Float64,Nothing}
    "Latitude of end point (°)"
    lat2::Union{Float64,Nothing}
    "Longitude of end point (°)"
    lon2::Union{Float64,Nothing}
    "Angular distace between start and end points (°)"
    a12::Union{Float64,Nothing}
    "Distance between start and end points (°)"
    s12::Union{Float64,Nothing}
    "Forward azimuth from start point to end point (°)"
    azi1::Union{Float64,Nothing}
    "Forward azimuth at end point from start point along great cricle"
    azi2::Union{Float64,Nothing}
    "Reduced length of the geodesic"
    m12::Union{Float64,Nothing}
    "First geodesic scale"
    M12::Union{Float64,Nothing}
    "Second geodesic scale"
    M21::Union{Float64,Nothing}
    "Area between the path from the first to the second point, and the equator (m²)"
    S12::Union{Float64,Nothing}
end

Result() = Result(nothing, nothing, nothing, nothing, nothing, nothing, nothing,
                  nothing, nothing, nothing, nothing, nothing)
