# Julia interface functions

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


## Functions
```@docs
forward
forward_deg
inverse
waypoints
```

## Included ellipsoids
```@docs
GeographicLib.WGS84
```
