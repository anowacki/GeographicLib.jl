"""
# GeographicLib

Compute distances and angles of geodesics (shortest paths) on a flattened sphere.

See the file `README.md` for full usage instructions.

## Overview

Two constructors and four main functions are provided with a Julia-like interface:

### Constructors
- `Geodesic` creates an instance of an ellipsoid and associated parameters for later computation.
- `GeodesicLine` creates a great circle, including information about the ellipsoid, which allows
  for multiple great circle calculations to be performed efficiently.

### `forward` and `forward_deg`
- `forward` computes the end point given a starting point, azimuth and distance in
  m (or whichever units the ellipsoid is defined in);
- `forward_deg` is the same but the distance from the starting point is defined
  by an angular distance in °.

Both of these functions can use either a `Geodesic` or `GeodesicLine` for the calculations.

### `inverse`
- `inverse` computes the distance and forward and backazimuths between two points
  on the flattened sphere.

## Underlying library
One can also access the implementation of the original library, which has been
literally transcribed into Julia.  These are exposed via:

- `GeographicLib.ArcDirect()`
- `GeographicLib.Direct()`
- `GeographicLib.Inverse()`

These operate as the original Python library `geographiclib`, except the first
argument to each is an ellipsoid as a `GeographicLib.Geodesics.Geodesic` object.
These can be constructed via the exported `Geodesic()` constructor.

## Attribution

GeographicLib.jl is a literal Julia transcription of the Python implementation of
the GeographicLib library by Charles F. F. Karney.

The algorithms are derived in

   Charles F. F. Karney,
   Algorithms for geodesics, J. Geodesy 87, 43-55 (2013),
   https://doi.org/10.1007/s00190-012-0578-z
   Addenda: https://geographiclib.sourceforge.io/geod-addenda.html

The original library is licensed under the following terms:

> Copyright (c) Charles Karney (2011-2017) <charles@karney.com> and licensed
> under the MIT/X11 License.  For more information, see
> https://geographiclib.sourceforge.io/

This Julia version is copyright (c) Andy Nowacki (2019) <a.nowacki@leeds.ac.uk>
and licensed under the MIT License.  See the file `LICENSE.md` for details.
"""
module GeographicLib

include("Constants.jl")
include("Math.jl")
include("GeodesicCapability.jl")
include("Geodesics.jl")
include("GeodesicLines.jl")

import .Constants, .Math, .GeodesicCapability, .Geodesics, .GeodesicLines

include("direct.jl")

using .Geodesics: Inverse, Geodesic
using .GeodesicLines: GeodesicLine, Position, ArcPosition, SetDistance, SetArc

include("inverse_line.jl")
include("show.jl")

export Geodesic, GeodesicLine, forward, forward_deg, inverse, waypoints

"Default ellipsoid of WGS84"
const WGS84 = Geodesic(Constants.WGS84_a, Constants.WGS84_f)

"""
    forward([ellipsoid::Geodesic=WGS84,] lon, lat, azi, dist) -> lon′, lat′, baz, dist, angle

Compute the final position when travelling from longitude `lon`°, latitude `lat`°,
along an azimuth of `azi`° for `dist` m (or whichever units the `ellipsoid`
is defined using).  The final coordinates are (`lon′`, `lat′`)°,
the backazimuth from the final point to the start is `baz`°, and the angular distance is
`angle`°.

If `ellipsoid` is not supplied, then [`WGS84`](@ref) is used by default.
"""
function forward(g::Geodesic, lon, lat, azi, dist)
    r = Direct(g, lat, lon, azi, dist, Geodesics.ALL)
    (lon=r.lon2, lat=r.lat2, baz=Math.AngNormalize(r.azi2 + 180), dist=dist, angle=r.a12)
end

forward(lon, lat, azi, dist) = forward(WGS84, lon, lat, azi, dist)

"""
    forward(a, f, lon, lat, azi, dist) -> lon′, lat′, baz, dist, angle

Compute the final point assuming an ellipsoid with semimajor axis `a` m
and flattening `f`.

Note that precomputing the ellipsoid with [`Geodesic`](@ref) and then reusing this
if multiple `forward` calculations are needed will be more efficient.
"""
forward(a, f, lon, lat, azi, dist) = forward(Geodesic(a, f), lon, lat, azi, dist)

"""
    forward(line::GeodesicLine, dist) -> lon′, lat′, baz, dist, angle

Compute the final point when travelling along a pre-computed great circle `line` for
a distance of `dist` m.  `angle` is the angular distance in °.
"""
function forward(line::GeodesicLine, dist)
    r = GeodesicLines.Position(line, dist)
    (lon=r.lon2, lat=r.lat2, baz=Math.AngNormalize(r.azi2 + 180), dist=dist, angle=r.a12)
end


"""
    forward_deg([ellipsoid::Geodesic=WGS84,] lon, lat, azi, angle) -> lon′, lat′, baz, dist, angle

Compute the final position when travelling from longitude `lon`°, latitude `lat`°,
along an azimuth of `azi`° for an angular distance of `angle`°.
The final coordinates are (`lon′`, `lat′`)°,
the backazimuth from the final point to the start is `baz`°, and the distance is
`dist` m.

If `ellipsoid` is not supplied, then WGS84 is used by default.
"""
function forward_deg(g::Geodesic, lon, lat, azi, angle)
    r = ArcDirect(g, lat, lon, azi, angle, Geodesics.ALL)
    (lon=r.lon2, lat=r.lat2, baz=Math.AngNormalize(r.azi2 + 180), dist=r.s12, angle=r.a12)
end

forward_deg(lon, lat, azi, angle) = forward_deg(WGS84, lon, lat, azi, angle)

"""

    forward_deg(a, f, lon, lat, azi, angle) -> lon′, lat′, baz, dist, angle

Compute the final point assuming an ellipsoid with semimajor radius `a` m
and flattening `f`.

Note that precomputing the ellipsoid with [`Geodesic`](@ref) and then reusing this
if multiple `forward_deg` calculations are needed will be more efficient.
"""
forward_deg(a, f, lon, lat, azi, angle) = forward_deg(Geodesic(a, f), lon, lat, azi, angle)

"""
    forward_deg(line::GeodesicLine, angle) -> lon, lat, baz, dist

Compute the final point when travelling along a pre-computed great circle `line` for
an angular distance of `angle` °.  `dist` is the distance in m.
"""
function forward_deg(line::GeodesicLine, angle)
    r = GeodesicLines.ArcPosition(line, angle)
    (lon=r.lon2, lat=r.lat2, baz=Math.AngNormalize(r.azi2 + 180), dist=r.s12, angle=r.a12)
end

"""
    inverse([ellipsoid::Geodesic=WGS84,] lon1, lat1, lon2, lat2) -> azi, baz, dist, angle

Compute for forward azimuth `azi`°, backazimuth `baz`°, surface distance `dist` m
and angular distance `angle`° when travelling from (`lon1`, `lat1`)° to a
second point (`lon2`, `lat2`)°.

If `ellipsoid` is not supplied, then WGS84 is used by default.
"""
function inverse(g::Geodesic, lon1, lat1, lon2, lat2)
    r = Inverse(g, lat1, lon1, lat2, lon2)
    (azi=r.azi1, baz=Math.AngNormalize(r.azi2 + 180), dist=r.s12, angle=r.a12)
end

inverse(lon1, lat1, lon2, lat2) = inverse(WGS84, lon1, lat1, lon2, lat2)

"""
    inverse(a, f, lon1, lat1, lon2, lat2) -> azi, baz, dist, angle

Compute the final point assuming an ellipsoid with semimajor radius `a` m
and flattening `f`.

Note that precomputing the ellipsoid with `Geodesic(a, f)` and then reusing this
if multiple `inverse` calculations are needed will be more efficient.
"""
inverse(a, f, lon1, lat1, lon2, lat2) = inverse(Geodesic(a, f), lon1, lat1, lon2, lat2)

"""
    GeodesicLine([ellipsoid::Geodesic.WGS84]; lon1, lat1, azi, lon2, lat2, angle, dist)

Construct a `GeodesicLine`, which may be used to efficiently compute many distances
along a great circle.  There are two ways to define the great circle this way:

1. Set a start point, azimuth, and optionally distance.  This requires the keyword arguments
   `lon1`, `lat1`, `azi1` (all °) and optionally either `angle` (angular distance, °)
   or distance `dist` (m).
2. Set a start point and end point.  This requires the keyword arguments
   `lon1`, `lat1`, `lon2` and `lat2` (all °).

If `ellipsoid` is not supplied, then WGS84 is used by default.

See [`forward`](@ref) and [`forward_deg`](@ref) for details of computing points along a `GeodesicLine`.
"""
function GeodesicLine(geod=WGS84; lon1, lat1, azi=nothing, lon2=nothing, lat2=nothing,
    angle=nothing, dist=nothing)
    if azi === nothing && any(x->x===nothing, (lon2, lat2))
        throw(ArgumentError("cannot define a GeodesicLine without either azi or (lon2, lat2)"))
    end
    if azi !== nothing
        (lon2 !== nothing || lat2 !== nothing) &&
            throw(ArgumentError("cannot define both azimuth and end position"))
        (angle !== nothing && dist !== nothing) &&
            throw(ArgumentError("cannot define both angle and dist"))
        if angle !== nothing
            ArcDirectLine(geod, lat1, lon1, azi, angle, Geodesics.ALL)
        elseif dist !== nothing
            DirectLine(geod, lat1, lon1, azi, dist, Geodesics.ALL)
        else
            GeodesicLine(geod, lat1, lon1, azi, caps=Geodesics.ALL)
        end
    elseif lon2 !== nothing && lat2 !== nothing
        (angle === nothing && dist == nothing) ||
            throw(ArgumentError("cannot define a dist as well as an end point"))
        InverseLine(geod, lat1, lon1, lat2, lon2, Geodesics.ALL)
    else
        throw(ArgumentError("invalid combination of keyword arguments"))
    end
end

"""
    waypoints(line::GeodesicLine; n, dist, angle) -> points

Return a set of `points` along a great circle `line` (which must have been specified with a 
distance or as between two points).  There are three options:

- Specify `n`, the number of points (including the endpoints)
- Specift `dist`, the distance between each point in m
- Specify `angle`, the angular distance between each point in °.

In all cases, the start and end points are always included.  When giving either `dist` or `angle`,
the penultimate point may not be respectively `dist` m or `angle`° away from the final point.

The output is a vector of named tuples as returned by [`forward`](@ref).
"""
function waypoints(line::GeodesicLine; n=nothing, dist=nothing, angle=nothing)
    isnan(line.a13) &&
        throw(ArgumentError("cannot compute waypoints for a line constructed without a distance or endpoint"))
    count(x->x!==nothing, (n, dist, angle)) == 1 ||
        throw(ArgumentError("only one keyword parameter can be given"))
    if n !== nothing
        n >= 2 || throw(ArgumentError("number of points must be 2 or more"))
        forward.(line, range(0, stop=line.s13, length=n))
    elseif dist !== nothing
        n = ceil(Int, line.s13/dist)
        [forward(line, min(dist*i, line.s13)) for i in 0:n]
    elseif angle !== nothing
        n = ceil(Int, line.a13/angle)
        [forward_deg(line, min(angle*i, line.a13)) for i in 0:n]
    end
end

end # module
