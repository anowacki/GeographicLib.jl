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

#### Forward calculations
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
(lon = 4.0582278226970505, lat = 4.075072441996237, baz = -134.8555604670512, dist = 1000, angle = 5.748708172166859)
```

#### Inverse calculations
Compute the azimuth, backazimuth and distance between two points:

```julia
julia> lon2, lat2 = 45, 45;

julia> inverse(lon1, lat1, lon2, lat2)
(azi = 35.41005890506594, baz = -125.10922617212486, dist = 6.6624727182103e6, angle = 60.01196771734598)
```

(Here, `baz` is the backazimuth from point 2 to point 1, whilst `angle` is the arc distance
measured in degrees between points as if they were on a sphere.)

#### Constructing great circles
To efficiently compute many points along a particular great circle, you can construct a
`GeodesicLine` (here, at 1000 km distances between Beijing airport and San Francisco
airport) and use `forward`:

```julia
julia> line = GeodesicLine(lon1=116.6, lat1=40.1, lon2=-122.4, lat2=37.6);

julia> forward.(line, 0:1000e3:10000e3)
11-element Array{NamedTuple{(:lon, :lat, :baz, :angle),NTuple{4,Float64}},1}:
 (lon = 116.6, lat = 40.1, baz = -137.0835839712501, angle = 0.0)                                           
 (lon = 125.44903079924097, lat = 46.37320813609803, baz = -131.00635460562273, angle = 8.999172866948838)  
 (lon = 136.4075140500135, lat = 51.78785851967508, baz = -122.70566872360234, angle = 17.995261013573796)  
 (lon = 149.93824895740542, lat = 55.92437254305949, baz = -111.75427031060497, angle = 26.98887852958424)  
 (lon = 165.90776020637412, lat = 58.27452472166077, baz = -98.31758202155277, angle = 35.980878576192254)  
 (lon = -176.96832804774255, lat = 58.434988533052156, baz = -83.70986035579932, angle = 44.972270315436404)
 (lon = -160.73052153000853, lat = 56.37430385916338, baz = -70.00076449597367, angle = 53.964121473898246) 
 (lon = -146.82672730321303, lat = 52.45769208832891, baz = -58.667901786243704, angle = 62.957455553072116)
 (lon = -135.52790977774458, lat = 47.19436392438814, baz = -50.0138069289103, angle = 71.95315308031782)   
 (lon = -126.41706065849593, lat = 41.02144776815703, baz = -43.656406099766116, angle = 80.95186600702041) 
 (lon = -118.93224695733755, lat = 34.24798773004601, baz = -39.073877341144225, angle = 89.95395339318391) 
```

#### Waypoints
If you have constructed a `GeodesicLine` between two points or specified a distance,
you can use the `waypoints` convenience function to compute a set of points along a
great circle.

Firstly, you can specify a set number of points along the line:

```julia
julia> waypoints(line, n=5)
5-element Array{NamedTuple{(:lon, :lat, :baz, :dist, :angle),NTuple{5,Float64}},1}:
 (lon = 116.6, lat = 40.1, baz = -137.0835839712501, dist = 0.0, angle = 0.0)                                                          
 (lon = 141.21330642828883, lat = 53.53055762971426, baz = -118.88359410725269, dist = 2.3784994975269474e6, angle = 21.39958966473992)
 (lon = 178.87381779849247, lat = 58.60690096032195, baz = -87.25623680042224, dist = 4.756998995053895e6, angle = 42.787351553799056) 
 (lon = -145.14838587689667, lat = 51.81242147405395, baz = -57.34286188749553, dist = 7.135498492580842e6, angle = 64.17620343175672) 
 (lon = -122.4, lat = 37.599999999999994, baz = -41.109730492903964, dist = 9.51399799010779e6, angle = 85.57848955531682)             
```

Or you can specify a set spacing between points along the line:
```julia
julia> waypoints(line, dist=5_000e3)
3-element Array{NamedTuple{(:lon, :lat, :baz, :dist, :angle),NTuple{5,Float64}},1}:
 (lon = 116.6, lat = 40.1, baz = -137.0835839712501, dist = 0.0, angle = 0.0)                                             
 (lon = -176.96832804774255, lat = 58.434988533052156, baz = -83.70986035579932, dist = 5.0e6, angle = 44.972270315436404)
 (lon = -122.4, lat = 37.599999999999994, baz = -41.109730492903964, dist = 9.51399799010779e6, angle = 85.57848955531682)

julia> waypoints(line, angle=20)
6-element Array{NamedTuple{(:lon, :lat, :baz, :dist, :angle),NTuple{5,Float64}},1}:
 (lon = 116.6, lat = 40.1, baz = -137.0835839712501, dist = 0.0, angle = 0.0)                                                         
 (lon = 139.19114607860084, lat = 52.83782284453118, baz = -120.50255714699239, dist = 2.2228860526324883e6, angle = 20.0)            
 (lon = 173.53783679104947, lat = 58.629539520620774, baz = -91.81254596963203, dist = 4.44699528316639e6, angle = 40.0)              
 (lon = -151.10367085049282, lat = 53.91890440185242, baz = -62.09291230954403, dist = 6.671174913353463e6, angle = 60.0)             
 (lon = -127.29426650297322, lat = 41.707094275305174, baz = -44.236119103725684, dist = 8.894239314095357e6, angle = 80.0)           
 (lon = -122.39999999999998, lat = 37.59999999999999, baz = -41.109730492903964, dist = 9.51399799010779e6, angle = 85.57848955531682)
```

### Traditional interface

GeographicLib.jl exposes the following functions which operate in the same way
as the C or Python interface to GeographicLib:

- `GeographicLib.ArcDirect`: forward computations using arc length
- `GeographicLib.Direct`: forward computations using unitful distance
- `GeographicLib.Inverse`: inverse computations

These all return extra information about the geodesic, including the area between
the geodesic and the equator.  Output is controlled by a mask.  See the docstring
for each of these functions for more information.

The following are also exposed:

- `GeographicLib.GeodesicLine`: construct a great circle from a starting position and azimuth
- `GeographicLib.ArcDirectLine`: construct a great circle from a starting position, azimuth and
  arc length, which can be used by `GeographicLib.Position` or `GeographicLib.ArcPosition` to compute
  points along the line
- `GeographicLib.DirectLine`: construct a great circle from a starting position, azimuth and
  distance, which can be used by `GeographicLib.Position` or `GeographicLib.ArcPosition` to compute
  points along the line
- `GeographicLib.InverseLine`: construct a great circle from a starting and end position,
  which can be used by `GeographicLib.Position` or `GeographicLib.ArcPosition` to compute
  points along the line
- `GeographicLib.Position`: calculate a point along a `GeographicLib.GeodesicLine` given
  a distance
- `GeographicLine.ArcPosition`: calculate a point along a `GeographicLine.GeodesicLine`
  given an arc length


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
