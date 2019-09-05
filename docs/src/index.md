# GeographicLib.jl

GeographicLib.jl is a Julia port of the geodesic (great circle) calculations
provided as part of Charles F. F. Karney’s [GeographicLib](https://geographiclib.sourceforge.io).  It is a literal transcription of the
[Python version](https://geographiclib.sourceforge.io/html/python/index.html),
and distributed under the same licence.

It allows for the computation of great circles (or ‘geodesics’) on a
uniaxial ellipsoid, including finding distances and azimuths between
two points, calculating the area of a geodesic polygon, and determing
the end point when travelling from a starting point a certain distance
and along a certain direction.

Most users should use the [Julia interface functions](@ref) to interact
with the package, but this also implements an interface as close as
possible to the Python interface.

[Examples](@ref) of usage are available.

## Contents

```@contents
```

## Index
```@index
```