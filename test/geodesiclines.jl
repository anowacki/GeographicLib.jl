using Test
using GeographicLib
import PyCall

pygeodesic = PyCall.pyimport_conda("geographiclib.geodesic", "geographiclib", "conda-forge")
pygeodesicline = PyCall.pyimport_conda("geographiclib.geodesicline", "geographiclib", "conda-forge")

pyg(a=1, f=0) = pygeodesic.Geodesic(a, f)
pygl(args...) = pygeodesicline.GeodesicLine(args...)

@testset "GeodesicLines" begin
    @testset "Construction" begin
        let a = 1234, f = 2*(rand() - 0.5),
                (lon1, lat1) = (360*(rand() - 0.5), 180*(rand() - 0.5)),
                azi1 = 360*rand()
            g = Geodesic(a, f)
            g′ = pyg(a, f)
            l = GeodesicLine(g, lat1, lon1, azi1)
            l′ = pygl(g′, lat1, lon1, azi1)
            for f in fieldnames(typeof(l))
                v = getfield(l, f)
                if f in propertynames(l′)
                    v′ = getproperty(l′, f)
                    if v isa AbstractArray || !isnan(v)
                        @test v ≈ v′ rtol=1e-15
                    else
                        @test isnan(v′)
                    end
                end
            end
            # Test for keyword construction with wrong arguments
            @test_throws ArgumentError GeodesicLine(g, lon1, lat1)
            @test_throws ArgumentError GeodesicLine(g, lon1, lat1, azi=azi1, lon2=0, lat2=0)
            @test_throws ArgumentError GeodesicLine(g, lon1, lat1, azi=azi1, dist=1, angle=1)
            # Keyword construction
            g1, g2 = GeodesicLine(g, lat1, lon1, azi1), GeodesicLine(g, lon1, lat1, azi=azi1)
            for f in fieldnames(typeof(f))
                v1, v2 = getfield((g1, g2), f)
                @test (isnan(v1) && isnan(v2)) || v1 == v2
            end
        end
    end

    @testset "GenPosition" begin
        let a = 1234, f = 0.3134079145161248, g = GeographicLib.Geodesics.Geodesic(a, f),
                lat1 = -51.408999679851675, lon1 = -40.04351048940153,
                azi1 = 79.76952674322507, Δ = 164.02419910896282
            l = GeographicLib.GeodesicLines.GeodesicLine(g, lat1, lon1, azi1)
            a12, lat2, lon2, azi2, s12, m12, M12, M21, S12 =
                GeographicLib.GeodesicLines._GenPosition(l, false, Δ,
                    GeographicLib.GeodesicCapability.STANDARD)
            @test a12 ≈ 9.18819804571738 rtol=1e-15
            @test lat2 ≈ -49.18652040518558 rtol=1e-15
            @test lon2 ≈ -30.443737771307752 rtol=1e-15
            @test azi2 ≈ 72.37176622421707 rtol=1e-15
            @test s12 ≈ 164.02419910896282 rtol=1e-15
            @test all(isnan, (m12, M12, M21, S12))
        end
    end

    @testset "Position" begin
        let (a, f, lon1, lat1, azi1, Δ) = (1234, -0.5833005266243414, 18.873553751969936,
                                           -19.529384224161888, 129.22750158031664,
                                           112.33064973397457)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            l = GeographicLib.GeodesicLines.GeodesicLine(g, lat1, lon1, azi1)
            r = GeographicLib.GeodesicLines.Position(l, Δ)
            @test r.lat1 ≈ -19.529384224161888 rtol=1e-15
            @test r.lon1 ≈ 18.873553751969936 rtol=1e-15
            @test r.azi1 ≈ 129.22750158031664 rtol=1e-15
            @test r.s12 ≈ 112.33064973397457 rtol=1e-15
            @test r.a12 ≈ 3.58210254436387 rtol=1e-15
            @test r.lat2 ≈ -21.19165849818401 rtol=1e-15
            @test r.lon2 ≈ 23.613521220477235 rtol=1e-15
            @test r.azi2 ≈ 127.57790778941455 rtol=1e-15
        end
    end

    @testset "ArcPosition" begin
        let (a, f, lon1, lat1, azi1, Δ) = (4321, 0.5745813186530309, 179.39481939005407,
                                           66.22442782311553, 19.377091988345583,
                                           151.07125158351164)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            l = GeographicLib.GeodesicLines.GeodesicLine(g, lat1, lon1, azi1)
            r = GeographicLib.GeodesicLines.ArcPosition(l, Δ)
            @test r.lat1 ≈ 66.22442782311553 rtol=1e-15
            @test r.lon1 ≈ 179.39481939005407 rtol=1e-15
            @test r.azi1 ≈ 19.377091988345583 rtol=1e-15
            @test r.s12 ≈ 8523.831339006269 rtol=1e-15
            @test r.a12 ≈ 151.07125158351164 rtol=1e-15
            @test r.lat2 ≈ -34.40549879164729 rtol=1e-15
            @test r.lon2 ≈ -27.352791133113328 rtol=1e-15
            @test r.azi2 ≈ 165.60583477635657 rtol=1e-15
        end
    end

    @testset "Set{Distance,Arc}" begin
        let (a, f, lon1, lat1, azi1, Δ) = (100000, -0.18722137258084448,
                -53.14989547414514, 84.04592897524329, 162.0349652709919, 92.30916749278542)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            l = GeographicLib.GeodesicLines.GeodesicLine(g, lat1, lon1, azi1)
            l = GeographicLib.GeodesicLines.SetDistance(l, Δ)
            @test l.a13 ≈ 0.05280569699601195 rtol=1e-15
            @test l.s13 == Δ
            l = GeographicLib.GeodesicLines.SetArc(l, Δ)
            @test l.a13 == Δ
            @test l.s13 ≈ 178439.61597913457 rtol=1e-15
        end
    end
end
