using Test
using GeographicLib
import PyCall

pygeodesic = PyCall.pyimport_conda("geographiclib.geodesic", "geographiclib")

pyg(a=1, f=0) = pygeodesic.Geodesic(a, f)

const G′ = pyg()

rtol = 1e-14

@testset "Geodesics" begin
    @testset "Constants" begin
        for s in (:GEOGRAPHICLIB_GEODESIC_ORDER, :tiny_, :tol0_, :tol1_, :tol2_, :tolb_,
                  :xthresh_, :nC3x_, :nC4x_, :maxit1_, :maxit2_)
            @test getfield(GeographicLib.Geodesics, s) == getproperty(G′, s)
        end
    end

    @testset "SinCosSeries" begin
        let sinp = true, sinx = -0.5707374343928929, cosx = 0.8211326208248082,
                c = [4.44659e-323, -0.142558, -0.0051905, -0.00050647, -6.96919e-5,
                     -1.21273e-5, -2.23265e-6]
            @test GeographicLib.Geodesics._SinCosSeries(sinp, sinx, cosx, c) ==
                G′._SinCosSeries(sinp, sinx, cosx, c)
        end
    end

    @testset "Astroid" begin
        let x = rand(), y = rand()
            @test GeographicLib.Geodesics._Astroid(x, y) == G′._Astroid(x, y)
        end
    end

    @testset "A1m1f" begin
        @test GeographicLib.Geodesics._A1m1f(0.44) == 0.8732392588857142
    end

    @testset "C1f" begin
        let eps = 0.03758347198675215, c = zeros(7), c′ = deepcopy(c)
            GeographicLib.Geodesics._C1f(eps, c)
            G′._C1f(eps, c′)
            @test c == c′
        end
    end

    @testset "C1pf" begin
        let eps = 0.015956192814408233, c = zeros(7),
            c′ = [0.0, 0.007976953981713705,  7.95375500593385e-5, 1.2265918324359732e-6,
                 2.2731089715865057e-8, 4.669162619873696e-10, 1.0228990879992899e-11]
            GeographicLib.Geodesics._C1pf(eps, c)
            @test c == c′
        end
    end

    @testset "A2m1f" begin
        let eps = 0.8825976003321706
            @test GeographicLib.Geodesics._A2m1f(eps) == -0.8251959782672741
        end
    end

    @testset "C2f" begin
        let eps = 0.015306268286591138, c = zeros(7)
            @test GeographicLib.Geodesics._C2f(eps, c) == [0.0, 0.007653358293351722,
                4.392956213074207e-5, 3.7355607893363093e-7, 3.75228413967185e-9,
                4.135015924677166e-11, 4.834779821088818e-13]
        end
    end

    @testset "Construction" begin
        let a = 1234, f = -0.5, g = GeographicLib.Geodesics.Geodesic(a, f), g′ = pyg(a, f)
            for f in fieldnames(typeof(g))
                @test getfield(g, f) ≈ getproperty(g′, f) rtol=rtol
            end
        end
    end

    @testset "Inverse" begin
        # Random point on random ellipsoid
        let a = 6371_000.0, f = rand()
            lon1, lat1 = 360*(rand() - 0.5), 180*(rand() - 0.5)
            lon2, lat2 = 360*(rand() - 0.5), 180*(rand() - 0.5)
            g = GeographicLib.Geodesics.Geodesic(a, f)
            g′ = pygeodesic.Geodesic(a, f)
            r = GeographicLib.Geodesics.Inverse(g, lat1, lon1, lat2, lon2)
            r′ = g′.Inverse(lat1, lon1, lat2, lon2)
            for f in fieldnames(typeof(r))
               if getfield(r, f) !== nothing
                   @test getfield(r, f) ≈ r′[String(f)] rtol=rtol
               end
            end
        end
        # Random point on WGS84
        let g = GeographicLib.WGS84
            lon1, lat1 = 360*(rand() - 0.5), 180*(rand() - 0.5)
            lon2, lat2 = 360*(rand() - 0.5), 180*(rand() - 0.5)
            g′ = pygeodesic.Geodesic.WGS84
            r = GeographicLib.Geodesics.Inverse(g, lat1, lon1, lat2, lon2, GeographicLib.Geodesics.ALL)
            r′ = g′.Inverse(lat1, lon1, lat2, lon2, g′.ALL)
            for f in fieldnames(typeof(r))
               if getfield(r, f) !== nothing
                   @test getfield(r, f) ≈ r′[String(f)] rtol=rtol
               end
            end
        end
        # Case of (lon,lat): (0,0) -> (170,0)
        let g = GeographicLib.WGS84
            r = GeographicLib.Geodesics.Inverse(g, 0, 0, 0, 170, GeographicLib.Geodesics.ALL)
            @test r.lat1 == 0
            @test r.lon1 == 0
            @test r.lat2 == 0
            @test r.lon2 == 170.0
            @test r.a12 ≈ 170.571895269566 rtol=rtol
            @test r.s12 ≈ 18924313.434856508 rtol=rtol
            @test r.azi1 ≈ 90.0 rtol=1e-15
            @test r.azi2 ≈ 90.0 rtol=1e-15
            @test r.m12 ≈ 1041298.8085522508 rtol=rtol
            @test r.M12 ≈ -0.986491928256342 rtol=rtol
            @test r.M21 ≈ -0.986491928256342 rtol=rtol
            @test r.S12 ≈ 0.0 atol=1e-15
        end
    end
end
