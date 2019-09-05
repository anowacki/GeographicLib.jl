# Julia interface functions

!!! note

    The Julia-style interface with which you should normally interact
    with GeographicLib.jl uses coordinates in the order **`lon`, `lat`**.
    Note that the original library uses `lat`, `lon` order, which is
    opposite our convention.


## Types and constructors

### `Geodesic`
The `Geodesic` type defines an ellipsoid on which subsequent great circle
calculations can be performed.

```@docs
Geodesic
```

### `GeodesicLine`
The `GeodesicLine` type includes an ellipsoid and defines a particular great
circle on that ellipsoid.

!!! note

    Calculating waypoints along a certain section of a `GeodesicLine`
    requires setting an endpoint when constructing it.  Use either
    the `lon2` and `lat2` arguments, or `azi` and a distance (either
    `dist` or `angle`).

```@docs
GeodesicLine(geod::Geodesic, lon1, lat1)
```

### `Polygon`
The `Polygon` type holds many points on an ellipsoid and can be used to
calculate the perimeter of a polygon or the area enclosed by it by call
[`properties`](@ref).  Use [`add_point!`](@ref) or [`add_edge!`](@ref)
to add points to a `Polygon`.

```@docs
Polygon
```

## Functions
### `Geodesic`s and `GeodesicLine`s
```@docs
forward
forward_deg
inverse
waypoints
```

### `Polygon`s
```@docs
add_point!
add_edge!
properties
```

## Included ellipsoids
```@docs
GeographicLib.WGS84
```
