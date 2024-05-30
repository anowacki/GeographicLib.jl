"""
# GLWrapper

Quick Julia wrapper of a few parts of GeographicLib, as exposed through
Proj.

This is only used for testing the Julia port of GeographicLib against
the C implementation.  For a maintained wrapper, see the
[Proj4.jl](https://github.com/JuliaGeo/Proj4.jl) package, though the `geod_gen*`
functions are not exposed there, and only default flags are passed.  Thus
extra values like m12, M12, S12 are not returned; hence this module.

## Setup

Set LIBGEOD, the path to the `libproj` library, below before importing the module.
"""
module GLWrapper

export GeodGeodesic,
       geod_direct,
       geod_gendirect,
       geod_geninverse,
       geod_init,
       geod_inverse

const LIBGEOD = "/opt/local/lib/proj9/lib/libproj.dylib"

struct Cdouble6
    x1::Cdouble
    x2::Cdouble
    x3::Cdouble
    x4::Cdouble
    x5::Cdouble
    x6::Cdouble
end

struct Cdouble15
    x1::Cdouble
    x2::Cdouble
    x3::Cdouble
    x4::Cdouble
    x5::Cdouble
    x6::Cdouble
    x7::Cdouble
    x8::Cdouble
    x9::Cdouble
    x10::Cdouble
    x11::Cdouble
    x12::Cdouble
    x13::Cdouble
    x14::Cdouble
    x15::Cdouble
end

struct Cdouble21
    x1::Cdouble
    x2::Cdouble
    x3::Cdouble
    x4::Cdouble
    x5::Cdouble
    x6::Cdouble
    x7::Cdouble
    x8::Cdouble
    x9::Cdouble
    x10::Cdouble
    x11::Cdouble
    x12::Cdouble
    x13::Cdouble
    x14::Cdouble
    x15::Cdouble
    x16::Cdouble
    x17::Cdouble
    x18::Cdouble
    x19::Cdouble
    x20::Cdouble
    x21::Cdouble
end

mutable struct GeodGeodesic
    a::Cdouble
    f::Cdouble
    f1::Cdouble
    e2::Cdouble
    ep2::Cdouble
    n::Cdouble
    b::Cdouble
    c2::Cdouble
    etol2::Cdouble

    # Arrays of parameters must be expanded manually,
    # currently (either inline, or in an immutable helper-type)
    # In the future, some of these restrictions may be reduced/eliminated.
    A3x::Cdouble6
    C3x::Cdouble15
    C4x::Cdouble21

    GeodGeodesic() = new()
    GeodGeodesic(a, f) = (g = new(); geod_init(g, a, f))
end

@enum GeodMask::Cuint begin
    GEOD_NONE          = 0                    # Calculate nothing
    GEOD_LATITUDE      = 1<<7  | 0            # Calculate latitude
    GEOD_LONGITUDE     = 1<<8  | 1<<3         # Calculate longitude
    GEOD_AZIMUTH       = 1<<9  | 0            # Calculate azimuth
    GEOD_DISTANCE      = 1<<10 | 1<<0         # Calculate distance
    GEOD_DISTANCE_IN   = 1<<11 | 1<<0 | 1<<1  # Allow distance as input 
    GEOD_REDUCEDLENGTH = 1<<12 | 1<<0 | 1<<2  # Calculate reduced length
    GEOD_GEODESICSCALE = 1<<13 | 1<<0 | 1<<2  # Calculate geodesic scale
    GEOD_AREA          = 1<<14 | 1<<4         # Calculate reduced length
    GEOD_ALL           = 0x7F80| 0x1F         # Calculate everything
end

@enum GeodFlags::Cuint begin
    GEOD_NOFLAGS      = 0      # No flags
    GEOD_ARCMODE      = 1<<0   # Position given in terms of arc distance
    GEOD_LONG_UNROLL  = 1<<15  # Unroll the longitude
end

Base.:|(a::Union{GeodMask,GeodFlags}, b::Union{GeodMask,GeodFlags}) = Cuint(a) | Cuint(b)

function geod_init(g::GeodGeodesic, a, f)
    ccall((:geod_init, LIBGEOD),
          Cvoid,
          (Ptr{Cvoid}, Cdouble, Cdouble),
          pointer_from_objref(g), a, f)
    g
end

function geod_direct(g::GeodGeodesic, lat1, lon1, azi1, s12)
    plat2, plon2, pazi2 = Ref{Cdouble}(), Ref{Cdouble}(), Ref{Cdouble}()
    ccall((:geod_direct, LIBGEOD),
          Cvoid,
          (Ptr{Cvoid}, Cdouble, Cdouble, Cdouble, Cdouble,
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          pointer_from_objref(g), lat1, lon1, azi1, s12, plat2, plon2, pazi2)
    (lat2=plat2[], lon2=plon2[], az2=pazi2[])
end

function geod_inverse(g::GeodGeodesic, lat1, lon1, lat2, lon2)
    ps12, pazi1, pazi2 = Ref{Cdouble}(), Ref{Cdouble}(), Ref{Cdouble}()
    ccall((:geod_inverse, LIBGEOD),
          Cvoid,
          (Ptr{Cvoid}, Cdouble, Cdouble, Cdouble, Cdouble,
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          pointer_from_objref(g), lat1, lon1, lat2, lon2, ps12, pazi1, pazi2)
    (s12=ps12[], azi1=pazi1[], azi2=pazi2[])
end

function geod_gendirect(g::GeodGeodesic, lat1, lon1, azi1, dist;
                        flags=(GEOD_NONE | GEOD_NOFLAGS), arc=false)
	plat2 = Ref{Cdouble}()
    plon2 = Ref{Cdouble}()
    pazi2 = Ref{Cdouble}()
    ps12 = Ref{Cdouble}()
    pm12 = Ref{Cdouble}()
    pM12 = Ref{Cdouble}()
    pM21 = Ref{Cdouble}()
    pS12 = Ref{Cdouble}()
    ccall((:geod_gendirect, LIBGEOD),
          Cvoid,
          (Ptr{Cvoid}, Cdouble, Cdouble, Cdouble, Cuint, Cdouble,
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble},
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          pointer_from_objref(g), lat1, lon1, azi1, flags, dist, plat2, plon2, pazi2, ps12, pm12, pM12, pM21, pS12)
    a12 = (arc ? dist : geod_geninverse(g, lat1, lon1, plat2[], plon2[]).a12)
    (lat1=lat1, lon1=lon1, lat2=plat2[], lon2=plon2[], azi1=azi1, azi2=pazi2[],
        a12=a12, s12=ps12[], m12=pm12[], M12=pM12[], M21=pM21[], S12=pS12[])
end

function geod_geninverse(g::GeodGeodesic, lat1, lon1, lat2, lon2)
	ps12 = Ref{Cdouble}()
    pazi1 = Ref{Cdouble}()
    pazi2 = Ref{Cdouble}()
    pm12 = Ref{Cdouble}()
    pM12 = Ref{Cdouble}()
    pM21 = Ref{Cdouble}()
    pS12 = Ref{Cdouble}()
    a12 = ccall((:geod_geninverse, LIBGEOD),
          Cdouble,
          (Ptr{Cvoid}, Cdouble, Cdouble, Cdouble, Cdouble,
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble},
              Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}),
          pointer_from_objref(g), lat1, lon1, lat2, lon2, ps12, pazi1, pazi2, pm12, pM12, pM21, pS12)
    (lat1=lat1, lon1=lon1, lat2=lat2, lon2=lon2,
        a12=a12, s12=ps12[], azi1=pazi1[], azi2=pazi2[], m12=pm12[],
        M12=pM12[], M21=pM21[], S12=pS12[])
end

end # module
