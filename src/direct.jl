"""
    Direct(geodesic, lat1, lon1, azi1, s12, outmask=Geodesics.STANDARD) -> result::Geodesics.Result

Solve the direct geodesic problem and return a `Geodesics.Result`
containing the parameters of interest

Input parameters:
`lat1`: latitude of the first point in degrees
`lon1`: longitude of the first point in degrees
`azi1`: azimuth at the first point in degrees
`s12`: the distance from the first point to the second in meters
`outmask`: a mask setting which output values are computed (see note below)

Compute geodesic starting at (`lat1`, `lon1`) with azimuth `azi1`
and length `s12`.  The default value of `outmask` is STANDARD, i.e.,
the `lat1`, `lon1`, `azi1`, `lat2`, `lon2`, `azi2`, `s12`, `a12`
entries are returned.

### Output mask

May be any combination of:
`Geodesics.EMPTY`, `Geodesics.LATITUDE`, `Geodesics.LONGITUDE`,
`Geodesics.AZIMUTH`, `Geodesics.DISTANCE`, `Geodesics.STANDARD`,
`Geodesics.DISTANCE_IN`, `Geodesics.REDUCEDLENGTH`, `Geodesics.GEODESICSCALE`,
`Geodesics.AREA`, `Geodesics.ALL` or `Geodesics.LONG_UNROLL`.
See the docstring for each for more information.

Flags are combined by bitwise or-ing values together, e.g.
`Geodesics.AZIMUTH | Geodesics.DISTANCE`.
"""
function Direct(self::Geodesics.Geodesic, lat1::T1, lon1::T2, azi1::T3, s12::T4,
           outmask = GeodesicCapability.STANDARD) where {T1,T2,T3,T4}

  T = float(promote_type(Float64, T1, T2, T3, T4))
  lat1, lon1, azi1, s12 = T.((lat1, lon1, azi1, s12))
  outmask = Int(outmask)

  a12, lat2, lon2, azi2, s12, m12, M12, M21, S12 = _GenDirect(self,
    lat1, lon1, azi1, false, s12, outmask)
  outmask &= Geodesics.OUT_MASK

  result_lat1 = Math.LatFix(lat1)
  result_lon1 = (outmask & Geodesics.LONG_UNROLL) > 0 ?
                lon1 :
                Math.AngNormalize(lon1)
  result_azi1 = Math.AngNormalize(azi1)
  result_s12 = s12
  result_a12 = a12
  result_lat2 = (outmask & Geodesics.LATITUDE) > 0 ? lat2 : nothing
  result_lon2 = (outmask & Geodesics.LONGITUDE) > 0 ? lon2 : nothing
  result_azi2 = (outmask & Geodesics.AZIMUTH) > 0 ? azi2 : nothing
  result_m12 = (outmask & Geodesics.REDUCEDLENGTH) > 0 ? m12 : nothing
  result_M12, result_M21 = (outmask & Geodesics.GEODESICSCALE) > 0 ? (M12, M21) : (nothing, nothing)
  result_S12 = (outmask & Geodesics.AREA) > 0 ? S12 : nothing
  Result(result_lat1, result_lon1, result_lat2, result_lon2, result_a12, result_s12,
         result_azi1, result_azi2, result_m12, result_M12, result_M21, result_S12)
end

"""
    ArcDirect(geodesic, lat1, lon1, azi1, a12, outmask=Geodesics.STANDARD) -> result::Geodesics.Result

Solve the direct geodesic problem and return a `Geodesics.Result`
containing the parameters of interest

Input parameters:
`lat1`: latitude of the first point in degrees
`lon1`: longitude of the first point in degrees
`azi1`: azimuth at the first point in degrees
`a12`: the angular distance from the first point to the second in °
`outmask`: a mask setting which output values are computed (see note below)

Compute geodesic starting at (`lat1`, `lon1`)° with azimuth `azi1`°
and arc length `a12`°.  The default value of `outmask` is STANDARD, i.e.,
the `lat1`, `lon1`, `azi1`, `lat2`, `lon2`, `azi2`, `s12`, `a12`
entries are returned.

### Output mask

May be any combination of:
`Geodesics.EMPTY`, `Geodesics.LATITUDE`, `Geodesics.LONGITUDE`,
`Geodesics.AZIMUTH`, `Geodesics.DISTANCE`, `Geodesics.STANDARD`,
`Geodesics.DISTANCE_IN`, `Geodesics.REDUCEDLENGTH`, `Geodesics.GEODESICSCALE`,
`Geodesics.AREA`, `Geodesics.ALL` or `Geodesics.LONG_UNROLL`.
See the docstring for each for more information.

Flags are combined by bitwise or-ing values together, e.g.
`Geodesics.AZIMUTH | Geodesics.DISTANCE`.
"""
function ArcDirect(self::Geodesics.Geodesic, lat1::T1, lon1::T2, azi1::T3, a12::T4,
           outmask = GeodesicCapability.STANDARD) where {T1,T2,T3,T4}

  T = float(promote_type(Float64, T1, T2, T3, T4))
  lat1, lon1, azi1, a12 = T.((lat1, lon1, azi1, a12))
  outmask = Int(outmask)

  a12, lat2, lon2, azi2, s12, m12, M12, M21, S12 = _GenDirect(self,
    lat1, lon1, azi1, true, a12, outmask)
  outmask &= Geodesics.OUT_MASK

  result_lat1 = Math.LatFix(lat1)
  result_lon1 = (outmask & Geodesics.LONG_UNROLL) > 0 ?
                lon1 :
                Math.AngNormalize(lon1)
  result_azi1 = Math.AngNormalize(azi1)
  result_a12 = a12
  result_s12 = (outmask & Geodesics.DISTANCE) > 0 ? s12 : nothing
  result_lat2 = (outmask & Geodesics.LATITUDE) > 0 ? lat2 : nothing
  result_lon2 = (outmask & Geodesics.LONGITUDE) > 0 ? lon2 : nothing
  result_azi2 = (outmask & Geodesics.AZIMUTH) > 0 ? azi2 : nothing
  result_m12 = (outmask & Geodesics.REDUCEDLENGTH) > 0 ? m12 : nothing
  result_M12, result_M21 = (outmask & Geodesics.GEODESICSCALE) > 0 ? (M12, M21) : (nothing, nothing)
  result_S12 = (outmask & Geodesics.AREA) > 0 ? S12 : nothing
  Result(result_lat1, result_lon1, result_lat2, result_lon2, result_a12, result_s12,
         result_azi1, result_azi2, result_m12, result_M12, result_M21, result_S12)
end

"""Private: General version of direct problem"""
function _GenDirect(self::Geodesics.Geodesic, lat1, lon1, azi1, arcmode, s12_a12, outmask)
  outmask = Int(outmask)
  # Automatically supply DISTANCE_IN if necessary
  if ! arcmode
      outmask |= Geodesics.DISTANCE_IN
  end
  line = GeodesicLines.GeodesicLine(self, lat1, lon1, azi1, caps=outmask)
  GeodesicLines._GenPosition(line, arcmode, s12_a12, outmask)
end
