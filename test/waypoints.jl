using Test
using GeographicLib

@testset "Waypoints" begin
    # Check for keyword argument construction
    @test_throws ArgumentError waypoints(GeodesicLine(lon1=0, lat1=0, azi=0))
    let line = GeodesicLine(lon1=0, lat1=0, azi=0, angle=10)
        @test_throws ArgumentError waypoints(line)
        @test_throws ArgumentError waypoints(line, n=3, angle=2)
        @test_throws ArgumentError waypoints(line, angle=2, dist=3)
        @test_throws ArgumentError waypoints(line, dist=3, n=3)
        @test_throws ArgumentError waypoints(line, n=2, angle=2, dist=3)
        @test_throws ArgumentError waypoints(line, n=1)
    end
    # Test the different ways to define the waypoints
    let g = Geodesic(1, 0), lon = 0, lat = 0, lon2 = 0, lat2 = 90
        line = GeodesicLine(g, lon1=lon, lat1=lat, lon2=lon2, lat2=lat2)
        for (w1, w2, w3) in zip(waypoints(line, n=91), waypoints(line, angle=1), waypoints(line, dist=deg2rad(1)))
            for f in fieldnames(typeof(w1))
                @test getfield(w1, f) ≈ getfield(w2, f) rtol=1e-15
                @test getfield(w2, f) ≈ getfield(w3, f) rtol=1e-15
            end
        end
    end
end