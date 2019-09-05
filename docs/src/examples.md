# Examples

This implementation of the geodesic parts of GeographicLib
allows you to do the following:
- Compute azimuths and distances between two know points: use
  [`inverse`](@ref).
- Compute the end point from some starting point, a direction and distance:
  use [`forward`](@ref) or [`forward_deg`](@ref).
- Calculate waypoints along a known great circle path: use
  [`GeodesicLine`](@ref) and [`waypoints`](@ref).
- Compute the area or perimeter of a polyon on the ellipsoid: use
  [`Polygon`](@ref) and [`properties`](@ref).

These examples show how to do each of these in practice.

(Note that these examples are taken from the
[original documentation](https://geographiclib.sourceforge.io/html/python/examples.html#).)

## Ellipsoids
By default, great circle calculations use the WGS84 ellipsoid.
You therefore do not need to specify the first `ellipse`
argument to the functions unless you want to specify your own ellipsoid.
However, to specify your own ellipsoid on which to compute great
circles, this is easily done:

```@repl example
using GeographicLib
semimajor_radius_m = 6378_388;
flattening = 1/297.0;
ellipse = Geodesic(semimajor_radius_m, flattening)
```

## Distance between two points
If you know the location of two points in longitude and latitude, use the
[`inverse`](@ref) function to find the distance between them, the azimuth
from the first point and backazimuth from the second point to the first:

```@repl example
lon1, lat1 = 174.81, -41.32; # Wellington, New Zealand
lon2, lat2 = -5.50, 40.96; # Salamanca, Spain
inverse(ellipse, lon1, lat1, lon2, lat2)
```

This returns a named tuple; the distance in m is given by the `.dist`
field, `.angle` gives the angular distance on the equivalent sphere,
`.azi` gives the forward azimuth and `.baz` the backazimuth.

## Moving a set distance from one point
If you know the starting point and want to know the end point from moving
a certain distance along a certain azimuth, use [`forward`](@ref).

```@repl example
forward(ellipse, 115.74, -32.06, 225, 2000e3) # 2000 km southwest of Perth, Australia
```

If you want to know the end point a certain angular distance away, use
[`forward_deg`](@ref):

```@repl example
forward_deg(ellipse, 115.74, -32.06, 225, 20) # 20° southwest of Perth
```

## Computing waypoints
Consider the great circle path from Beijing Airport (116.6°E, 40.1°N) to San
Fransisco Airport (122.4°W, 37.6°N). Compute waypoints and azimuths
at intervals of 1000 km by creating a [`GeodesicLine`](@ref) and then
using [`waypoints`](@ref):

```@repl example
line = GeodesicLine(ellipse, 116.6, 40.1, lon2=-122.4, lat2=37.6)
waypoints(line, dist=1000e3)
```

If you just want some number of points along the way, use the `n` keyword
argument:

```@repl example
waypoints(line, n=10)
```

Or set the distance between points in terms of angle:

```@repl example
waypoints(line, angle=10)
```

## Measuring areas
Measure the area of Antarctica by using a [`Polygon`](@ref) and
[`properties`](@ref):

```@repl example
antarctica = [
    ( -58,-63.1), (-74,-72.9), (-102,-71.9), (-102,-74.9), (-131,-74.3),
    (-163,-77.5), (163,-77.4), ( 172,-71.7), ( 140,-65.9), ( 113,-65.7),
    (  88,-66.6), ( 59,-66.9), (  25,-69.8), (  -4,-70.0), ( -14,-71.0),
    ( -33,-77.3), (-46,-77.9), ( -61,-74.7)
  ];
lons = first.(antarctica);
lats = last.(antarctica);
p = Polygon(ellipse, lons, lats);
properties(p)
```

Equivalently, call [`add_point!`](@ref) multiple times:

```@repl example
p = Polygon(ellipse);
for (lon, lat) in  antarctica
    add_point!(p, lon, lat)
end
properties(p)
```
