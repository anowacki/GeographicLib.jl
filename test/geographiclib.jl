using Test
using GeographicLib

@testset "GeographicLib" begin
    @testset "inverse" begin
        let g = GeographicLib.WGS84, a = GeographicLib.Constants.WGS84_a,
                f = GeographicLib.Constants.WGS84_f
            r = GeographicLib.Geodesics.Inverse(g, 0, 0, 0, 170)
            r′ = inverse(g, 0, 0, 170, 0)
            @test r.a12 == r′.angle
            @test r.s12 == r′.dist
            @test r.azi1 == r′.azi
            @test GeographicLib.Math.AngDiff(r.azi2, r′.baz + 180)[1] ≈ 0 atol=1e-13
            @test inverse(g, 0, 0, 170, 0) == inverse(0, 0, 170, 0)
            @test inverse(a, f, 0, 0, 170, 0) == inverse(0, 0, 170, 0)
        end
    end

    @testset "forward" begin
        let g = GeographicLib.WGS84, lon = 360*rand(), lat = 180*(rand() - 0.5),
                azi = 360*rand(), dist = 10_000_000rand(),
                a = GeographicLib.Constants.WGS84_a,
                f = GeographicLib.Constants.WGS84_f
            r = GeographicLib.Direct(g, lat, lon, azi, dist)
            r′ = forward(g, lon, lat, azi, dist)
            @test r.lon2 == r′.lon
            @test r.lat2 == r′.lat
            @test GeographicLib.Math.AngDiff(r.azi2, r′.baz + 180)[1] ≈ 0 atol=1e-13
            @test forward(g, lon, lat, azi, dist) == forward(lon, lat, azi, dist)
            @test forward(a, f, lon, lat, azi, dist) == forward(lon, lat, azi, dist)
        end
    end

    @testset "forward_deg" begin
        let g = GeographicLib.WGS84, lon = 360*rand(), lat = 180*(rand() - 0.5),
                azi = 360*rand(), dist = 360rand(),
                a = GeographicLib.Constants.WGS84_a,
                f = GeographicLib.Constants.WGS84_f
            r = GeographicLib.ArcDirect(g, lat, lon, azi, dist)
            r′ = forward_deg(g, lon, lat, azi, dist)
            @test r.lon2 == r′.lon
            @test r.lat2 == r′.lat
            @test GeographicLib.Math.AngDiff(r.azi2, r′.baz + 180)[1] ≈ 0 atol=1e-13
            @test forward_deg(g, lon, lat, azi, dist) == forward_deg(lon, lat, azi, dist)
            @test forward_deg(a, f, lon, lat, azi, dist) == forward_deg(lon, lat, azi, dist)
        end
    end
end