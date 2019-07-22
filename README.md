# GeographicLib.jl

Julia port of Charles F. F. Karney's [GeographicLib](https://geographiclib.sourceforge.io).

[![Build Status](https://travis-ci.org/anowacki/GeographicLib.jl.svg?branch=master)](https://travis-ci.org/anowacki/GeographicLib.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/hy3339eys3jhgme0?svg=true)](https://ci.appveyor.com/project/AndyNowacki/geographiclib-jl)
[![Coverage Status](https://coveralls.io/repos/github/anowacki/GeographicLib.jl/badge.svg?branch=master)](https://coveralls.io/github/anowacki/GeographicLib.jl?branch=master)


## About

GeographicLib allows you to accurately compute properties of
[geodesics](https://en.wikipedia.org/wiki/Geodesic) on a flattened sphere (e.g., Earth).

At present, only forward (point-and-heading) and inverse (point-to-point)
calculations of geodesics; implementation of polygons and geodesic lines
is still in progress.

The calculations in this package are accurate to at least the same precision as those
obtained with the original GeographicLib as distributed with the
[Proj library](https://proj.org).  That is, forward and inverse computations give
final coordinates or distances accurate to nm.


## Installation

Until the package is registered, you can install the package like so:

```julia
julia> ] # Press ']' to enter pkg mode
(v1.1) pkg> add https://github.com/anowacki/GeographicLib.jl
```


## Using

The package exposes a simple Julia interface, plus a literal translation of
the interface of the Python port of GeographicLib.

### Julia-style interface

Create an ellipsoid by providing the semimajor radius and flattening to
the `Geodesic` constructor:

```julia
julia> using GeographicLib

julia> geod = Geodesic(10_000, 1/300) # 10 km radius, flattening 1/300
Geodesic:
           a: 10000.0
           f: 0.0033333333333333335
         _f1: 0.9966666666666667
         _e2: 0.006655555555555556
        _ep2: 0.006700148767910874
          _n: 0.0016694490818030053
          _b: 9966.666666666668
         _c2: 9.977785199322024e7
      _etol2: 3.653069644177423e-8
        _A3x: [-0.0234375, -0.0469272, -0.0628132, -0.250208, -0.499165, 1.0]
        _C3x: [0.0234375, 0.0390886, 0.0469532, 0.125, 0.249583, 0.0195313, 0.0234505, 0.0468227, 0.0623436, 0.0136719, 0.023394, 0.0259635, 0.0136719, 0.0136262, 0.00820313]
        _C4x: [0.00646021, 0.00350353, 0.0347433, -0.0192163, -0.199238, 0.666222, 0.000111, 0.00342683, -0.00951084, -0.0189348  …  0.000745921, -0.00414209, -0.00504247, 0.00758518, -0.00215657, -0.00196271, 0.00361053, -0.000947201, 0.00204173, 0.00129164]
```

Compute the end point found by travelling from a point along a given azimuth for
a given distance (in m, or whatever units you used to construct the `geod`):

```julia
julia> lon1, lat1 = 0, 0;

julia> azi, dist = 45, 1000; # 1 km along 45°

julia> forward(geod, lon1, lat1, azi, dist)
(lon = 4.0582278226970505, lat = 4.075072441996237, baz = 225.1444395329488)
```

Compute the azimuth, backazimuth and distance between two points:

```julia
julia> lon2, lat2 = 45, 45;

julia> inverse(lon1, lat1, lon2, lat2)
(azi = 35.41005890506594, baz = -125.10922617212486, dist = 6.6624727182103e6, angle = 60.01196771734598)
```

(Here, `baz` is the backazimuth from point 2 to point 1, whilst `angle` is the arc distance
measured in degrees between points as if they were on a sphere.)

### Traditional interface

GeographicLib.jl exposes the following functions which operate in the same way
as the C or Python interface to GeographicLib:

- `GeographicLib.ArcDirect`: forward computations using arc length
- `GeographicLib.Direct`: forward computations using unitful distance
- `GeographicLib.Inverse`: inverse computations

These all return extra information about the geodesic, including the area between
the geodesic and the equator.  Output is controlled by a mask.  See the docstring
for each of these functions for more information.


## Testing

To perform some of its tests, the package relies on the Python port of GeographicLib.
Hence if you do `pkg> test`, PyCall will attempt to import `geographiclib` and
install it if possible.

You may also run `julia script/test_GeodTest.jl` which compares the output of this
package and the routines in `libproj` to a set of test results computed with
high precision.  For this purpose, you need to have
(Proj installed)[https://proj.org/install.html] and will need to edit the script
to point to the location of the `libproj` library.

Neither of these tests are necessary to use GeographicLib.jl normally.


## References

- C. F. F. Karney, Transverse Mercator with an accuracy of a few nanometers,
  J. Geodesy 85(8), 475–485 (Aug. 2011).
  doi:[10.1007/s00190-011-0445-3](https://doi.org/10.1007/s00190-011-0445-3)
- C. F. F. Karney, Algorithms for geodesics, J. Geodesy 87(1), 43–55 (Jan. 2013).
  doi:[10.1007/s00190-012-0578-z](https://doi.org/10.1007/s00190-012-0578-z)