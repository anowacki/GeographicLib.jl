using Test
using GeographicLib
using GeographicLib: Geodesics

@testset "Geodesic lines" begin
    @testset "Position" begin
        # Test values taken from https://geographiclib.sourceforge.io/1.49/python/examples.html#computing-waypoints
        let gl = GeographicLib.InverseLine(GeographicLib.WGS84, 40.1, 116.6, 37.6, -122.4)
            py_results = """
            distance latitude longitude azimuth
            0 40.10000 116.60000 42.91642
            1000000 46.37321 125.44903 48.99365
            2000000 51.78786 136.40751 57.29433
            3000000 55.92437 149.93825 68.24573
            4000000 58.27452 165.90776 81.68242
            5000000 58.43499 183.03167 96.29014
            6000000 56.37430 199.26948 109.99924
            7000000 52.45769 213.17327 121.33210
            8000000 47.19436 224.47209 129.98619
            9000000 41.02145 233.58294 136.34359
            9513998 37.60000 237.60000 138.89027
            """
            ds = 1_000_000
            n = ceil(Int, gl.s13/ds)
            for i in 0:n
                s = min(ds*i, gl.s13)
                result = GeographicLib.Position(gl, s,
                    outmask = Geodesics.STANDARD | Geodesics.LONG_UNROLL)
                irow = i + 2
                test_vals = split(py_results, '\n')[irow]
                for (column, field) in enumerate((:s12, :lat2, :lon2, :azi2))
                    test_val = parse(Float64, split(test_vals)[column])
                    @test round(getfield(result, field), digits=5) ≈ test_val
                end
            end
        end
    end

    @testset "ArcPosition" begin
        # Test values taken from https://geographiclib.sourceforge.io/1.49/python/examples.html#computing-waypoints
        let gl = GeographicLib.InverseLine(GeographicLib.WGS84, 40.1, 116.6, 37.6, -122.4,
                Geodesics.LATITUDE | Geodesics.LONGITUDE)
            py_results = """
            latitude longitude
            40.10000 116.60000
            40.82573 117.49243
            41.54435 118.40447
            42.25551 119.33686
            42.95886 120.29036
            43.65403 121.26575
            44.34062 122.26380
            ...
            39.82385 235.05331
            39.08884 235.91990
            38.34746 236.76857
            37.60000 237.60000
            """
            da = 1
            n = ceil(Int, gl.a13/da)
            da = gl.a13/n
            for i in 0:n
                # Skip missing test data
                7 <= i <= n - 4 && continue
                a = da*i
                result = GeographicLib.ArcPosition(gl, a,
                    outmask = Geodesics.LATITUDE | Geodesics.LONGITUDE | Geodesics.LONG_UNROLL)
                irow = i <= 6 ? i + 2 : 13 - (n - i)
                test_vals = split(py_results, '\n')[irow]
                for (column, field) in enumerate((:lat2, :lon2))
                    test_val = parse(Float64, split(test_vals)[column])
                    @test round(getfield(result, field), digits=5) ≈ test_val
                end
            end
        end
    end

    # Compare with computation without intermediate GeodesicLine construction
    @testset "forward" begin
        let lon = 360rand(), lat = 180rand() - 90, azi = 360rand(), distances = 40_000e3 .* rand(10)
            for l in (
                    GeodesicLine(lon, lat, azi=azi),
                    GeodesicLine(lon, lat, azi=azi, dist=1e6rand()))
                for dist in distances
                    result = forward(lon, lat, azi, dist)
                    glresult = forward(l, dist)
                    @test result == glresult
                end
            end
        end
    end

    @testset "forward_deg" begin
        let lon = 360rand(), lat = 180rand() - 90, azi = 360rand(), distances = 720 .* rand(10)
            for l in (
                    GeodesicLine(lon, lat, azi=azi),
                    GeodesicLine(lon, lat, azi=azi, angle=360rand()))
                for dist in distances
                    result = forward_deg(lon, lat, azi, dist)
                    glresult = forward_deg(l, dist)
                    @test result == glresult
                end
            end
        end
    end
end
