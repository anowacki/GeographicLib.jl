# Traditional GeographicLib interface

As well as the [Julia interface functions](@ref) functions,
GeographicLib.jl exposes an interface as similar as possible to
that as implemeted in the
[original library](https://geographiclib.sourceforge.io/html/geodesic.html).

## Types and constructors

[`Geodesic`](@ref)s and [`GeodesicLine`](@ref)s are constructed as in the
Julia-style interface, but with an additional method for `GeodesicLine`:

```@docs
GeographicLib.GeodesicLine(geod::Geodesic, lat1, lon1, azi1)
```

## Output masks

As in the traditional interface, the exact output from a call to any of the
[functions](#Functions-1) is controlled by passing in an output mask.
(See the [Python documentation](https://geographiclib.sourceforge.io/html/python/interface.html#outmask-and-caps) for details.)

This is a bitwise-or combination of flags from the module
`GeographicLib.GeodesicCapability`.

To use these easily, `import GeographicLib.GeodesicCapability` and define
a utility ‘alias’, for example:

```@repl
using GeographicLib
const Mask = GeographicLib.GeodesicCapability
mask = Mask.LATITUDE | Mask.LONGITUDE # Only compute longitude and latitude
g = GeographicLib.WGS84;
GeographicLib.Direct(g, 0, 0, 10, 10, mask)
```


## Output

Calculations with `Direct`, `ArcDirect`, `Position`, `ArcPosition` and 
`Inverse` return a `Result` type which contains fields with values
filled by the calculation.  When these are not made (due to the flags set in
[output masks](#Output-masks-1)), fields are `nothing`.

```@docs
GeographicLib.Geodesics.Result
```


## Functions
```@docs
GeographicLib.Direct
GeographicLib.ArcDirect
GeographicLib.Inverse
```
