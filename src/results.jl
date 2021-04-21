# Struct holding results of the GeographicLib interface

"""
    Result

Type holding the result of a forward or inverse calculation using a geodesic.

If fields have not been calculated because of the presence/absence of any
flags when performing the calculation, the field will be `nothing`.

### Fields

These are user-accesible.

- `lat1`: Latitude of starting point (°)
- `lon1`: Longitude of starting point (°)
- `lat2`: Latitude of end point (°)
- `lon2`: Longitude of end point (°)
- `a12`: Angular distace between start and end points (°)
- `s12`: Distance between start and end points (°)
- `azi1`: Forward azimuth from start point to end point (°)
- `azi2`: Forward azimuth at end point from start point along great cricle
- `m12`: Reduced length of the geodesic
- `M12`: First geodesic scale
- `M21`: Second geodesic scale
- `S12`: Area between the path from the first to the second point, and the equator (m²)
"""
Base.@kwdef struct Result
    "Latitude of starting point (°)"
    lat1::Union{Float64,Nothing} = nothing
    "Longitude of starting point (°)"
    lon1::Union{Float64,Nothing} = nothing
    "Latitude of end point (°)"
    lat2::Union{Float64,Nothing} = nothing
    "Longitude of end point (°)"
    lon2::Union{Float64,Nothing} = nothing
    "Angular distace between start and end points (°)"
    a12::Union{Float64,Nothing} = nothing
    "Distance between start and end points (°)"
    s12::Union{Float64,Nothing} = nothing
    "Forward azimuth from start point to end point (°)"
    azi1::Union{Float64,Nothing} = nothing
    "Forward azimuth at end point from start point along great cricle"
    azi2::Union{Float64,Nothing} = nothing
    "Reduced length of the geodesic"
    m12::Union{Float64,Nothing} = nothing
    "First geodesic scale"
    M12::Union{Float64,Nothing} = nothing
    "Second geodesic scale"
    M21::Union{Float64,Nothing} = nothing
    "Area between the path from the first to the second point, and the equator (m²)"
    S12::Union{Float64,Nothing} = nothing
end
