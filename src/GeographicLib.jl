"""
# GeographicLib

Compute distances and angles of geodesics (shortest paths) on a flattened sphere.

## Overview

Two main functions are provided with a Julia-like interface:

### `forward` and `forward_deg`
- `forward` computes the end point given a starting point, azimuth and distance in
  m (or whichever units the ellipsoid is defined in);
- `forward_deg` is the same but the distance from the starting point is defined
  by an angular distance in °.

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

import .Geodesics: Inverse, Geodesic
import .GeodesicLines: GeodesicLine, Position, ArcPosition, SetDistance, SetArc

include("show.jl")

export Geodesic, GeodesicLine, forward, forward_deg, inverse

const WGS84 = Geodesic(Constants.WGS84_a, Constants.WGS84_f)

"""
    forward([ellipsoid::Geodesic=WGS84,] lon, lat, azi, dist) -> lon′, lat′, baz

Compute the final position when travelling from longitude `lon`°, latitude `lat`°,
along an azimuth of `azi`° for `dist` m (or whichever units the `ellipsoid`
is defined using).  The final coordinates are (`lon′`, `lat′`)°
and the backazimuth from the final point to the start is `baz`°.

If `ellipsoid` is not supplied, then WGS84 is used by default.
"""
function forward(g::Geodesic, lon, lat, azi, dist)
    r = Direct(g, lat, lon, azi, dist, Geodesics.ALL)
    (lon=r.lon2, lat=r.lat2, baz=(r.azi2 + 180))
end
forward(lon, lat, azi, dist) = forward(WGS84, lon, lat, azi, dist)

"""
    forward(a, f, lon, lat, azi, dist)

Compute the final point assuming an ellipsoid with semimajor axis `a` m
and flattening `f`.

Note that precomputing the ellipsoid with `Geodesic(a, f)` and then reusing this
if multiple `forward` calculations are needed will be more efficient.
"""
forward(a, f, lon, lat, azi, dist) = forward(Geodesic(a, f), lon, lat, azi, dist)

"""
    forward_deg([ellipsoid::Geodesic=WGS84,] lon, lat, azi, dist) -> lon′, lat′, baz

Compute the final position when travelling from longitude `lon`°, latitude `lat`°,
along an azimuth of `azi`° for an angular distance of `dist`°.
The final coordinates are (`lon′`, `lat′`)°
and the backazimuth from the final point to the start is `baz`°.

If `ellipsoid` is not supplied, then WGS84 is used by default.

    forward_deg(a, f, lon, lat, azi, dist)

Compute the final point assuming an ellipsoid with semimajor radius `a` m
and flattening `f`.
"""
function forward_deg(g::Geodesic, lon, lat, azi, dist)
    r = ArcDirect(g, lat, lon, azi, dist, Geodesics.ALL)
    (lon=r.lon2, lat=r.lat2, baz=(r.azi2 + 180))
end
forward_deg(lon, lat, azi, dist) = forward_deg(WGS84, lon, lat, azi, dist)
forward_deg(a, f, lon, lat, azi, dist) = forward_deg(Geodesic(a, f), lon, lat, azi, dist)

"""
    inverse([ellipsoid::Geodesic=WGS84,] lon1, lat1, lon2, lat2) -> azi, baz, dist, angle

Compute for forward azimuth `azi`°, backazimuth `baz`°, surface distance `dist` m
and angular distance `angle`° when travelling from (`lon1`, `lat1`)° to a
second point (`lon2`, `lat2`)°.

If `ellipsoid` is not supplied, then WGS84 is used by default.

    inverse(a, f, lon1, lat1, lon2, lat2)

Compute the final point assuming an ellipsoid with semimajor radius `a` m
and flattening `f`.

Note that precomputing the ellipsoid with `Geodesic(a, f)` and then reusing this
if multiple `inverse` calculations are needed will be more efficient.
"""
function inverse(g::Geodesic, lon1, lat1, lon2, lat2)
    r = Inverse(g, lat1, lon1, lat2, lon2)
    (azi=r.azi1, baz=Math.AngNormalize(r.azi2 + 180), dist=r.s12, angle=r.a12)
end
inverse(lon1, lat1, lon2, lat2) = inverse(WGS84, lon1, lat1, lon2, lat2)
inverse(a, f, lon1, lat1, lon2, lat2) = inverse(Geodesic(a, f), lon1, lat1, lon2, lat2)

end # module
