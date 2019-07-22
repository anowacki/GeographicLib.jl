using Test
using GeographicLib

@testset "Direct" begin
    @testset "GenDirect" begin
        let (a, f, lon1, lat1, azi1, Δ) = (100000, 0.7753829671825798,
                135.49433174337074, 17.336774824225323, 259.7276820991133, 350.8322324468192)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            r = GeographicLib._GenDirect(g, lat1, lon1, azi1, true, Δ, GeographicLib.GeodesicCapability.STANDARD)
            @test r[1] ≈ 350.8322324468192 rtol=1e-15
            @test r[2] ≈ 23.541784571786934 rtol=1e-15
            @test r[3] ≈ 44.156390683280875 rtol=1e-15
            @test r[4] ≈ -99.51228356429226 rtol=1e-15
            @test r[5] ≈ 159097.92503024824 rtol=1e-15
            @test all(isnan, r[6:end])
        end
    end

    @testset "Direct" begin
        let (a, f, lon1, lat1, azi1, Δ) = (84489.26700321426, 0.9877944136964056,
            107.03411603309745, -23.24729991186748, 84.62363642219825, 106.47959091469139)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            r = GeographicLib.Direct(g, lat1, lon1, azi1, Δ)
            @test r.lat1 ≈ -23.24729991186748 rtol=1e-13
            @test r.lon1 ≈ 107.03411603309745 rtol=1e-13
            @test r.lat2 ≈ 19.525912034579594 rtol=1e-13
            @test r.lon2 ≈ 107.27817171543914 rtol=1e-13
            @test r.a12 ≈ 5.846532097494768 rtol=1e-13
            @test r.s12 ≈ 106.47959091469139 rtol=1e-13
            @test r.azi1 ≈ 84.62363642219825 rtol=1e-13
            @test r.azi2 ≈ 84.62097169538406 rtol=1e-13
        end
    end

    @testset "ArcDirect" begin
        let (a, f, lon1, lat1, azi1, Δ) = (32367.519663372103, -0.24686888934518691,
                104.14382348502483, -84.3601546570069, 317.481386262021, 42.87766576143766)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            r = GeographicLib.ArcDirect(g, lat1, lon1, azi1, Δ)
            @test r.lat1 ≈ -84.3601546570069 rtol=1e-14
            @test r.lon1 ≈ 104.14382348502483 rtol=1e-14
            @test r.lat2 ≈ -37.47031626600088 rtol=1e-14
            @test r.lon2 ≈ 64.02403561562656 rtol=1e-14
            @test r.a12 ≈ 42.87766576143766 rtol=1e-14
            @test r.s12 ≈ 25558.326685164957 rtol=1e-14
            @test r.azi1 ≈ -42.518613737979024 rtol=1e-14
            @test r.azi2 ≈ -4.23284106142266 rtol=1e-14
        end
    end
end
