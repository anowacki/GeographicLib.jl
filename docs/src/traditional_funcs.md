# Traditional GeographicLib interface

As well as the [Julia interface functions](@ref) functions,
GeographicLib.jl exposes an interface as similar as possible to
that as implemeted in the
[Python version](https://geographiclib.sourceforge.io/html/python/index.html)
of the original library.

!!! note

    For consistency with the original Python interface, coordinates are
    given in the order `lat`, `lon` to the ‘traditional’ interface.
    This is the **opposite order** to the Julia-style interface,
    which sticks with `lon`, `lat` in line with many other packages.

## Types and constructors

[`Geodesic`](@ref)s, [`GeodesicLine`](@ref)s and [`Polygon`](@ref)s
are constructed as in the
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
GeographicLib.Position
GeographicLib.GeodesicLines.SetDistance
GeographicLib.GeodesicLines.SetArc
```

!!! note

    Unlike the Python interface, the `SetPosition` and `SetArc` functions
    do not change the `GeodesicLine` struct, but return an updated copy.
    Make sure to use a pattern like `line = SetArc(line, azi, angle)` when
    using these functions.
