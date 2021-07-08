# GeographicLib.jl

Julia port of Charles F. F. Karney's [GeographicLib](https://geographiclib.sourceforge.io).

[![Build Status](https://github.com/anowacki/GeographicLib.jl/workflows/CI/badge.svg)](https://github.com/anowacki/GeographicLib.jl/actions)
[![Coverage Status](https://coveralls.io/repos/github/anowacki/GeographicLib.jl/badge.svg?branch=master)](https://coveralls.io/github/anowacki/GeographicLib.jl?branch=master)

### Documentation
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://anowacki.github.io/GeographicLib.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://anowacki.github.io/GeographicLib.jl/dev)

## About

GeographicLib allows you to accurately compute properties of
[geodesics](https://en.wikipedia.org/wiki/Geodesic) on a flattened sphere (e.g., Earth).

## Documentation

For full details of using the package, see the
[latest documentation](https://anowacki.github.io/GeographicLib.jl/dev).

## Testing

To perform some of its tests, the package relies on the Python port of GeographicLib.
Hence if you do `pkg> test`, PyCall will attempt to import `geographiclib` and
install it if possible.

You may also run `julia script/test_GeodTest.jl` which compares the output of this
package and the routines in `libproj` to a set of test results computed with
high precision.  For this purpose, you need to have
[Proj installed](https://proj.org/install.html) and will need to edit the script
to point to the location of the `libproj` library.

Neither of these tests are necessary to use GeographicLib.jl normally.


## References

- C. F. F. Karney, Transverse Mercator with an accuracy of a few nanometers,
  J. Geodesy 85(8), 475–485 (Aug. 2011).
  doi:[10.1007/s00190-011-0445-3](https://doi.org/10.1007/s00190-011-0445-3)
- C. F. F. Karney, Algorithms for geodesics, J. Geodesy 87(1), 43–55 (Jan. 2013).
  doi:[10.1007/s00190-012-0578-z](https://doi.org/10.1007/s00190-012-0578-z)
