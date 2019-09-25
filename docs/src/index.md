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
with the package, but this package also implements a ‘traditional’
interface which works as closely as possible to the Python interface.

[Examples](@ref) of usage are available.

## Contents

```@contents
```

## Index
```@index
```

## References

Some of the algorithms used in this package can be found in Charles
Karney’s papers:

- C. F. F. Karney, Transverse Mercator with an accuracy of a few nanometers,
  J. Geodesy 85(8), 475–485 (Aug. 2011).
  doi:[10.1007/s00190-011-0445-3](https://doi.org/10.1007/s00190-011-0445-3)
- C. F. F. Karney, Algorithms for geodesics, J. Geodesy 87(1), 43–55 (Jan. 2013).
  doi:[10.1007/s00190-012-0578-z](https://doi.org/10.1007/s00190-012-0578-z)

A fuller reference list for the methods can be found
[here](https://geographiclib.sourceforge.io/geodesic-papers/biblio.html).
