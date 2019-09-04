# Examples

## Ellipsoids
By default, great circle calculations use the WGS84 ellipsoid.
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
Consider the geodesic between Beijing Airport (40.1N, 116.6E) and San
Fransisco Airport (37.6N, 122.4W). Compute waypoints and azimuths at intervals
of 1000 km by creating a [`GeodesicLine`](@ref) and then using
[`waypoints`](@ref):

```@repl example
line = GeodesicLine(ellipse, 116.6, 40.1, lon2=-122.4, lat2=37.6)
waypoints(line, dist=1000e3)
```
