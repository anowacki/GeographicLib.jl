var documenterSearchIndex = {"docs":
[{"location":"julia_funcs/#Julia-interface-functions","page":"Julia interface","title":"Julia interface functions","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"note: Note\nThe Julia-style interface with which you should normally interact with GeographicLib.jl uses coordinates in the order lon, lat. Note that the original library uses lat, lon order, which is opposite our convention.","category":"page"},{"location":"julia_funcs/#Types-and-constructors","page":"Julia interface","title":"Types and constructors","text":"","category":"section"},{"location":"julia_funcs/#Geodesic","page":"Julia interface","title":"Geodesic","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"The Geodesic type defines an ellipsoid on which subsequent great circle calculations can be performed.","category":"page"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"Geodesic","category":"page"},{"location":"julia_funcs/#GeographicLib.Geodesics.Geodesic","page":"Julia interface","title":"GeographicLib.Geodesics.Geodesic","text":"Geodesic(a, f) -> geodesic\n\nSet up an ellipsoid for geodesic calculations.  a is the semimajor radius of the ellipsoid, whilst flattening is given by f.\n\n\n\n\n\n","category":"type"},{"location":"julia_funcs/#GeodesicLine","page":"Julia interface","title":"GeodesicLine","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"The GeodesicLine type includes an ellipsoid and defines a particular great circle on that ellipsoid.","category":"page"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"note: Note\nCalculating waypoints along a certain section of a GeodesicLine requires setting an endpoint when constructing it.  Use either the lon2 and lat2 arguments, or azi and a distance (either dist or angle).","category":"page"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"GeodesicLine(geod::Geodesic, lon1, lat1)","category":"page"},{"location":"julia_funcs/#GeographicLib.GeodesicLines.GeodesicLine-Tuple{Geodesic, Any, Any}","page":"Julia interface","title":"GeographicLib.GeodesicLines.GeodesicLine","text":"GeodesicLine([ellipsoid::Geodesic.WGS84,] lon1, lat1; azi, lon2, lat2, angle, dist)\n\nConstruct a GeodesicLine, which may be used to efficiently compute many distances along a great circle.  Set the coordinates of the starting point lon1° and lat1°. There are two ways to define the great circle this way:\n\nSet a start point, azimuth, and optionally distance.  This requires the keyword arguments azi1 (all °) and optionally either angle (angular distance, °) or distance dist (m).\nSet a start point and end point.  This requires the keyword arguments lon2 and lat2 (all °).\n\nIf ellipsoid is not supplied, then WGS84 is used by default.\n\nSee forward and forward_deg for details of computing points along a GeodesicLine.\n\n\n\n\n\n","category":"method"},{"location":"julia_funcs/#Polygon","page":"Julia interface","title":"Polygon","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"The Polygon type holds many points on an ellipsoid and can be used to calculate the perimeter of a polygon or the area enclosed by it by call properties.  Use add_point! or add_edge! to add points to a Polygon.","category":"page"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"Polygon","category":"page"},{"location":"julia_funcs/#GeographicLib.Polygons.Polygon","page":"Julia interface","title":"GeographicLib.Polygons.Polygon","text":"Polygon([ellipsoid::Geodesic=WGS84,] polyline=false)\n\nConstruct a Polygon, which contains a set of points on a certain ellipsoid.\n\nWith this construction, the Polygon contains no points.\n\nIf polyline is true, then the Polygon will not accumulate area and instead only its perimeter can be calculated.\n\n\n\n\n\nPolygon([ellipsoid::Geodesic=WGS84,] lons, lat) -> polygon\n\nConstruct a polygon from arrays of coordinates lons and lats, optionally specifying an ellipsoid, which defaults to WGS84.\n\nCalculate the polygon's area and perimeter with properties.\n\n\n\n\n\n","category":"type"},{"location":"julia_funcs/#Functions","page":"Julia interface","title":"Functions","text":"","category":"section"},{"location":"julia_funcs/#Geodesics-and-GeodesicLines","page":"Julia interface","title":"Geodesics and GeodesicLines","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"forward\nforward_deg\ninverse\nwaypoints","category":"page"},{"location":"julia_funcs/#GeographicLib.forward","page":"Julia interface","title":"GeographicLib.forward","text":"forward([ellipsoid::Geodesic=WGS84,] lon, lat, azi, dist) -> lon′, lat′, baz, dist, angle\n\nCompute the final position when travelling from longitude lon°, latitude lat°, along an azimuth of azi° for dist m (or whichever units the ellipsoid is defined using).  The final coordinates are (lon′, lat′)°, the backazimuth from the final point to the start is baz°, and the angular distance is angle°.\n\nIf ellipsoid is not supplied, then WGS84 is used by default.\n\n\n\n\n\nforward(a, f, lon, lat, azi, dist) -> lon′, lat′, baz, dist, angle\n\nCompute the final point assuming an ellipsoid with semimajor axis a m and flattening f.\n\nNote that precomputing the ellipsoid with Geodesic and then reusing this if multiple forward or forward_deg calculations are needed will be more efficient.\n\n\n\n\n\nforward(line::GeodesicLine, dist) -> lon′, lat′, baz, dist, angle\n\nCompute the final point when travelling along a pre-computed great circle line for a distance of dist m.  angle is the angular distance in °.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#GeographicLib.forward_deg","page":"Julia interface","title":"GeographicLib.forward_deg","text":"forward_deg([ellipsoid::Geodesic=WGS84,] lon, lat, azi, angle) -> lon′, lat′, baz, dist, angle\n\nCompute the final position when travelling from longitude lon°, latitude lat°, along an azimuth of azi° for an angular distance of angle°. The final coordinates are (lon′, lat′)°, the backazimuth from the final point to the start is baz°, and the distance is dist m.\n\nIf ellipsoid is not supplied, then WGS84 is used by default.\n\n\n\n\n\nforward_deg(a, f, lon, lat, azi, angle) -> lon′, lat′, baz, dist, angle\n\nCompute the final point assuming an ellipsoid with semimajor radius a m and flattening f.\n\nNote that precomputing the ellipsoid with Geodesic and then reusing this if multiple forward_deg calculations are needed will be more efficient.\n\n\n\n\n\nforward_deg(line::GeodesicLine, angle) -> lon, lat, baz, dist\n\nCompute the final point when travelling along a pre-computed great circle line for an angular distance of angle °.  dist is the distance in m.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#GeographicLib.inverse","page":"Julia interface","title":"GeographicLib.inverse","text":"inverse([ellipsoid::Geodesic=WGS84,] lon1, lat1, lon2, lat2) -> azi, baz, dist, angle\n\nCompute for forward azimuth azi°, backazimuth baz°, surface distance dist m and angular distance angle° when travelling from (lon1, lat1)° to a second point (lon2, lat2)°.\n\nIf ellipsoid is not supplied, then WGS84 is used by default.\n\n\n\n\n\ninverse(a, f, lon1, lat1, lon2, lat2) -> azi, baz, dist, angle\n\nCompute the final point assuming an ellipsoid with semimajor radius a m and flattening f.\n\nNote that precomputing the ellipsoid with Geodesic(a, f) and then reusing this if multiple inverse calculations are needed will be more efficient.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#GeographicLib.waypoints","page":"Julia interface","title":"GeographicLib.waypoints","text":"waypoints(line::GeodesicLine; n, dist, angle) -> points\n\nReturn a set of points along a great circle line (which must have been specified with a  distance or as between two points).  There are three options:\n\nSpecify n, the number of points (including the endpoints)\nSpecift dist, the distance between each point in m\nSpecify angle, the angular distance between each point in °.\n\nIn all cases, the start and end points are always included.  When giving either dist or angle, the penultimate point may not be respectively dist m or angle° away from the final point.\n\nThe output is a vector of named tuples as returned by forward or forward_deg.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#Polygons","page":"Julia interface","title":"Polygons","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"add_point!\nadd_edge!\nproperties","category":"page"},{"location":"julia_funcs/#GeographicLib.add_point!","page":"Julia interface","title":"GeographicLib.add_point!","text":"add_point!(polygon, lon, lat) -> polygon\n\nAdd a point to a geodesic polygon in order to later compute its perimeter and area with properties.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#GeographicLib.add_edge!","page":"Julia interface","title":"GeographicLib.add_edge!","text":"add_edge!(polygon, azi, dist) -> polygon\n\nAdd a point to a polygon by specifying the azimuth azi (°) and distance dist (m) from the previous point, in order to later compute its perimeter and area with properties.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#GeographicLib.properties","page":"Julia interface","title":"GeographicLib.properties","text":"properties(polygon::Polygon) -> npoints, perimeter, area\n\nReturn the number of points npoints, perimeter (m) and area (m²) of the geodesic polygon.\n\n\n\n\n\n","category":"function"},{"location":"julia_funcs/#Included-ellipsoids","page":"Julia interface","title":"Included ellipsoids","text":"","category":"section"},{"location":"julia_funcs/","page":"Julia interface","title":"Julia interface","text":"GeographicLib.WGS84","category":"page"},{"location":"julia_funcs/#GeographicLib.WGS84","page":"Julia interface","title":"GeographicLib.WGS84","text":"Ellipsoid of the WGS84 system, with a semimajor radius of 6.378137e6 m and flattening 0.0033528106647474805.\n\n\n\n\n\n","category":"constant"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"This implementation of the geodesic parts of GeographicLib allows you to do the following:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Compute azimuths and distances between two know points: use inverse.\nCompute the end point from some starting point, a direction and distance: use forward or forward_deg.\nCalculate waypoints along a known great circle path: use GeodesicLine and waypoints.\nCompute the area or perimeter of a polyon on the ellipsoid: use Polygon and properties.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"These examples show how to do each of these in practice.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Note that these examples are taken from the original documentation.)","category":"page"},{"location":"examples/#Ellipsoids","page":"Examples","title":"Ellipsoids","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"By default, great circle calculations use the WGS84 ellipsoid. You therefore do not need to specify the first ellipse argument to the functions unless you want to specify your own ellipsoid. However, to specify your own ellipsoid on which to compute great circles, this is easily done:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"using GeographicLib\nsemimajor_radius_m = 6378_388;\nflattening = 1/297.0;\nellipse = Geodesic(semimajor_radius_m, flattening)","category":"page"},{"location":"examples/#Distance-between-two-points","page":"Examples","title":"Distance between two points","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"If you know the location of two points in longitude and latitude, use the inverse function to find the distance between them, the azimuth from the first point and backazimuth from the second point to the first:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"lon1, lat1 = 174.81, -41.32; # Wellington, New Zealand\nlon2, lat2 = -5.50, 40.96; # Salamanca, Spain\ninverse(ellipse, lon1, lat1, lon2, lat2)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"This returns a named tuple; the distance in m is given by the .dist field, .angle gives the angular distance on the equivalent sphere, .azi gives the forward azimuth and .baz the backazimuth.","category":"page"},{"location":"examples/#Moving-a-set-distance-from-one-point","page":"Examples","title":"Moving a set distance from one point","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"If you know the starting point and want to know the end point from moving a certain distance along a certain azimuth, use forward.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"forward(ellipse, 115.74, -32.06, 225, 2000e3) # 2000 km southwest of Perth, Australia","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"If you want to know the end point a certain angular distance away, use forward_deg:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"forward_deg(ellipse, 115.74, -32.06, 225, 20) # 20° southwest of Perth","category":"page"},{"location":"examples/#Computing-waypoints","page":"Examples","title":"Computing waypoints","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Consider the great circle path from Beijing Airport (116.6°E, 40.1°N) to San Fransisco Airport (122.4°W, 37.6°N). Compute waypoints and azimuths at intervals of 1000 km by creating a GeodesicLine and then using waypoints:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"line = GeodesicLine(ellipse, 116.6, 40.1, lon2=-122.4, lat2=37.6)\nwaypoints(line, dist=1000e3)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"If you just want some number of points along the way, use the n keyword argument:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"waypoints(line, n=10)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Or set the distance between points in terms of angle:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"waypoints(line, angle=10)","category":"page"},{"location":"examples/#Measuring-areas","page":"Examples","title":"Measuring areas","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Measure the area of Antarctica by using a Polygon and properties:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"antarctica = [\n    ( -58,-63.1), (-74,-72.9), (-102,-71.9), (-102,-74.9), (-131,-74.3),\n    (-163,-77.5), (163,-77.4), ( 172,-71.7), ( 140,-65.9), ( 113,-65.7),\n    (  88,-66.6), ( 59,-66.9), (  25,-69.8), (  -4,-70.0), ( -14,-71.0),\n    ( -33,-77.3), (-46,-77.9), ( -61,-74.7)\n  ];\nlons = first.(antarctica);\nlats = last.(antarctica);\np = Polygon(ellipse, lons, lats);\nproperties(p)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Equivalently, call add_point! multiple times:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"p = Polygon(ellipse);\nfor (lon, lat) in  antarctica\n    add_point!(p, lon, lat)\nend\nproperties(p)","category":"page"},{"location":"traditional_funcs/#Traditional-GeographicLib-interface","page":"Traditional interface","title":"Traditional GeographicLib interface","text":"","category":"section"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"As well as the Julia interface functions functions, GeographicLib.jl exposes an interface as similar as possible to that as implemeted in the Python version of the original library.","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"note: Note\nFor consistency with the original Python interface, coordinates are given in the order lat, lon to the ‘traditional’ interface. This is the opposite order to the Julia-style interface, which sticks with lon, lat in line with many other packages.","category":"page"},{"location":"traditional_funcs/#Types-and-constructors","page":"Traditional interface","title":"Types and constructors","text":"","category":"section"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"Geodesics, GeodesicLines and Polygons are constructed as in the Julia-style interface, but with an additional method for GeodesicLine:","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"GeographicLib.GeodesicLine(geod::Geodesic, lat1, lon1, azi1)","category":"page"},{"location":"traditional_funcs/#GeographicLib.GeodesicLines.GeodesicLine-Tuple{Geodesic, Any, Any, Any}","page":"Traditional interface","title":"GeographicLib.GeodesicLines.GeodesicLine","text":"GeodesicLine(geod::Geodesic, lat1, lon1, azi1; caps, salp1, calp1) -> line\n\nCreate a GeodesicLine with starting latitude lat1° and longitude lon1°, and azimuth azi1°.\n\nControl the capabilities of the line with caps.  Optionally specify the sine and cosine of the azimuth at point 1, respectively salp1 and calp1.\n\n\n\n\n\n","category":"method"},{"location":"traditional_funcs/#Output-masks","page":"Traditional interface","title":"Output masks","text":"","category":"section"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"As in the traditional interface, the exact output from a call to any of the functions is controlled by passing in an output mask. (See the Python documentation for details.)","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"This is a bitwise-or combination of flags from the module GeographicLib.GeodesicCapability.","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"To use these easily, import GeographicLib.GeodesicCapability and define a utility ‘alias’, for example:","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"using GeographicLib\nconst Mask = GeographicLib.GeodesicCapability\nmask = Mask.LATITUDE | Mask.LONGITUDE # Only compute longitude and latitude\ng = GeographicLib.WGS84;\nGeographicLib.Direct(g, 0, 0, 10, 10, mask)","category":"page"},{"location":"traditional_funcs/#Output","page":"Traditional interface","title":"Output","text":"","category":"section"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"Calculations with Direct, ArcDirect, Position, ArcPosition and  Inverse return a Result type which contains fields with values filled by the calculation.  When these are not made (due to the flags set in output masks), fields are nothing.","category":"page"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"GeographicLib.Geodesics.Result","category":"page"},{"location":"traditional_funcs/#GeographicLib.Result","page":"Traditional interface","title":"GeographicLib.Result","text":"Result\n\nType holding the result of a forward or inverse calculation using a geodesic.\n\nIf fields have not been calculated because of the presence/absence of any flags when performing the calculation, the field will be nothing.\n\nFields\n\nThese are user-accesible.\n\nlat1: Latitude of starting point (°)\nlon1: Longitude of starting point (°)\nlat2: Latitude of end point (°)\nlon2: Longitude of end point (°)\na12: Angular distace between start and end points (°)\ns12: Distance between start and end points (°)\nazi1: Forward azimuth from start point to end point (°)\nazi2: Forward azimuth at end point from start point along great cricle\nm12: Reduced length of the geodesic\nM12: First geodesic scale\nM21: Second geodesic scale\nS12: Area between the path from the first to the second point, and the equator (m²)\n\n\n\n\n\n","category":"type"},{"location":"traditional_funcs/#Functions","page":"Traditional interface","title":"Functions","text":"","category":"section"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"GeographicLib.Direct\nGeographicLib.ArcDirect\nGeographicLib.Inverse\nGeographicLib.Position\nGeographicLib.GeodesicLines.SetDistance\nGeographicLib.GeodesicLines.SetArc","category":"page"},{"location":"traditional_funcs/#GeographicLib.Direct","page":"Traditional interface","title":"GeographicLib.Direct","text":"Direct(geodesic, lat1, lon1, azi1, s12, outmask=Geodesics.STANDARD) -> result::Geodesics.Result\n\nSolve the direct geodesic problem and return a Geodesics.Result containing the parameters of interest\n\nInput parameters: lat1: latitude of the first point in degrees lon1: longitude of the first point in degrees azi1: azimuth at the first point in degrees s12: the distance from the first point to the second in meters outmask: a mask setting which output values are computed (see note below)\n\nCompute geodesic starting at (lat1, lon1) with azimuth azi1 and length s12.  The default value of outmask is STANDARD, i.e., the lat1, lon1, azi1, lat2, lon2, azi2, s12, a12 entries are returned.\n\nOutput mask\n\nMay be any combination of: Geodesics.EMPTY, Geodesics.LATITUDE, Geodesics.LONGITUDE, Geodesics.AZIMUTH, Geodesics.DISTANCE, Geodesics.STANDARD, Geodesics.DISTANCE_IN, Geodesics.REDUCEDLENGTH, Geodesics.GEODESICSCALE, Geodesics.AREA, Geodesics.ALL or Geodesics.LONG_UNROLL. See the docstring for each for more information.\n\nFlags are combined by bitwise or-ing values together, e.g. Geodesics.AZIMUTH | Geodesics.DISTANCE.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/#GeographicLib.ArcDirect","page":"Traditional interface","title":"GeographicLib.ArcDirect","text":"ArcDirect(geodesic, lat1, lon1, azi1, a12, outmask=Geodesics.STANDARD) -> result::Geodesics.Result\n\nSolve the direct geodesic problem and return a Geodesics.Result containing the parameters of interest\n\nInput parameters: lat1: latitude of the first point in degrees lon1: longitude of the first point in degrees azi1: azimuth at the first point in degrees a12: the angular distance from the first point to the second in ° outmask: a mask setting which output values are computed (see note below)\n\nCompute geodesic starting at (lat1, lon1)° with azimuth azi1° and arc length a12°.  The default value of outmask is STANDARD, i.e., the lat1, lon1, azi1, lat2, lon2, azi2, s12, a12 entries are returned.\n\nOutput mask\n\nMay be any combination of: Geodesics.EMPTY, Geodesics.LATITUDE, Geodesics.LONGITUDE, Geodesics.AZIMUTH, Geodesics.DISTANCE, Geodesics.STANDARD, Geodesics.DISTANCE_IN, Geodesics.REDUCEDLENGTH, Geodesics.GEODESICSCALE, Geodesics.AREA, Geodesics.ALL or Geodesics.LONG_UNROLL. See the docstring for each for more information.\n\nFlags are combined by bitwise or-ing values together, e.g. Geodesics.AZIMUTH | Geodesics.DISTANCE.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/#GeographicLib.Geodesics.Inverse","page":"Traditional interface","title":"GeographicLib.Geodesics.Inverse","text":"Inverse(geodesic, lat1, lon1, lat2, lon2, outmask=STANDARD) -> result::Result\n\nSolve the inverse geodesic problem and return a Result containing the parameters of interest.\n\nInput arguments:\n\nlat1: latitude of the first point in degrees\nlon1: longitude of the first point in degrees\nlat2: latitude of the second point in degrees\nlon2: longitude of the second point in degrees\noutmask: a mask setting which output values are computed (see note below)\n\nCompute geodesic between (lat1, lon1) and (lat2, lon2). The default value of outmask is Geodesics.STANDARD, i.e., the lat1, lon1, azi1, lat2, lon2, azi2, s12, a12 entries are returned.\n\nOutput mask\n\nMay be any combination of: Geodesics.EMPTY, Geodesics.LATITUDE, Geodesics.LONGITUDE, Geodesics.AZIMUTH, Geodesics.DISTANCE, Geodesics.STANDARD, Geodesics.DISTANCE_IN, Geodesics.REDUCEDLENGTH, Geodesics.GEODESICSCALE, Geodesics.AREA, Geodesics.ALL or Geodesics.LONG_UNROLL. See the docstring for each for more information.\n\nFlags are combined by bitwise or-ing values together, e.g. Geodesics.AZIMUTH | Geodesics.DISTANCE.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/#GeographicLib.GeodesicLines.Position","page":"Traditional interface","title":"GeographicLib.GeodesicLines.Position","text":"Position(line::GeodesicLine, s12, outmask=STANDARD) -> result::Result\n\nFind the position on the line given s12, the distance from the first point to the second in metres.\n\nThe default value of outmask is STANDARD, i.e., the lat1, lon1, azi1, lat2, lon2, azi2, s12, a12 entries are returned.  The GeodesicLine object must have been constructed with the DISTANCE_IN capability.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/#GeographicLib.GeodesicLines.SetDistance","page":"Traditional interface","title":"GeographicLib.GeodesicLines.SetDistance","text":"SetDistance(line::GeodesicLine, s13) -> line′::GeodesicLine\n\nSpecify the position of point 3 in terms of distance from point 1 to point 3 in meters\n\nReturn a new GeodesicLine with s13 and a13 set.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/#GeographicLib.GeodesicLines.SetArc","page":"Traditional interface","title":"GeographicLib.GeodesicLines.SetArc","text":"SetArc(line::GeodesicLine, a13) -> line′::GeodesicLine\n\nSpecify the position of point 3 in terms of spherical arc length from point 1 to point 3 in degrees.\n\nReturn a new GeodesicLine with a13 and s13 set.\n\n\n\n\n\n","category":"function"},{"location":"traditional_funcs/","page":"Traditional interface","title":"Traditional interface","text":"note: Note\nUnlike the Python interface, the SetPosition and SetArc functions do not change the GeodesicLine struct, but return an updated copy. Make sure to use a pattern like line = SetArc(line, azi, angle) when using these functions.","category":"page"},{"location":"#GeographicLib.jl","page":"Home","title":"GeographicLib.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"GeographicLib.jl is a Julia port of the geodesic (great circle) calculations provided as part of Charles F. F. Karney’s GeographicLib.  It is a literal transcription of the Python version, and distributed under the same licence.","category":"page"},{"location":"","page":"Home","title":"Home","text":"It allows for the computation of great circles (or ‘geodesics’) on a uniaxial ellipsoid, including finding distances and azimuths between two points, calculating the area of a geodesic polygon, and determing the end point when travelling from a starting point a certain distance and along a certain direction.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Most users should use the Julia interface functions to interact with the package, but this package also implements a ‘traditional’ interface which works as closely as possible to the Python interface.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Examples of usage are available.","category":"page"},{"location":"#Contents","page":"Home","title":"Contents","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#Index","page":"Home","title":"Index","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#References","page":"Home","title":"References","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Some of the algorithms used in this package can be found in Charles Karney’s papers:","category":"page"},{"location":"","page":"Home","title":"Home","text":"C. F. F. Karney, Transverse Mercator with an accuracy of a few nanometers, J. Geodesy 85(8), 475–485 (Aug. 2011). doi:10.1007/s00190-011-0445-3\nC. F. F. Karney, Algorithms for geodesics, J. Geodesy 87(1), 43–55 (Jan. 2013). doi:10.1007/s00190-012-0578-z","category":"page"},{"location":"","page":"Home","title":"Home","text":"A fuller reference list for the methods can be found here.","category":"page"}]
}
