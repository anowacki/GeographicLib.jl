using Test
using GeographicLib
import PyCall

pymaths = PyCall.pyimport_conda("geographiclib.geomath", "geographiclib")

@testset "Maths" begin
    @test GeographicLib.Math.digits == pymaths.Math.digits
    @test GeographicLib.Math.epsilon == pymaths.Math.epsilon
    @test GeographicLib.Math.minval == pymaths.Math.minval
    @test GeographicLib.Math.maxval == pymaths.Math.maxval
    let x = rand(), y = rand()
        @test GeographicLib.Math.sq(x) == pymaths.Math.sq(x)
        @test GeographicLib.Math.cbrt(x) == pymaths.Math.cbrt(x)
        @test GeographicLib.Math.log1p(x) ≈ pymaths.Math.log1p(x) rtol=1e-15
        @test GeographicLib.Math.atanh(x) ≈ pymaths.Math.atanh(x) rtol=1e-15
        @test GeographicLib.Math.copysign(x, y) == pymaths.Math.copysign(x, y)
        xx, yy = GeographicLib.Math.norm(x, y)
        xx′, yy′ = pymaths.Math.norm(x, y)
        @test xx ≈ xx′ rtol=1e-15
        @test yy ≈ yy′ rtol=1e-15
        s, t = GeographicLib.Math.sum(x, y)
        s′, t′ = pymaths.Math.sum(x, y)
        @test s == s′
        @test t == t′
    end
    let N = 4, p = rand(8), s = rand(1:3), x = rand()
        @test GeographicLib.Math.polyval(N, p, s, x) ≈ pymaths.Math.polyval(N, p, s, x)
        @test GeographicLib.Math.polyval(3, [1, 4, 64, 0, 256], 0,
                                         0.00075625) == 0.04840228808876001
    end
    let x = 1080*(rand() - 0.5), a = 360*(rand() - 0.5), b = 360*(rand() - 0.5)
        @test GeographicLib.Math.AngRound(x) == pymaths.Math.AngRound(x)
        @test GeographicLib.Math.AngNormalize(x) == pymaths.Math.AngNormalize(x)
        @test GeographicLib.Math.LatFix(x) === pymaths.Math.LatFix(x)
        @test GeographicLib.Math.AngDiff(a, b) == pymaths.Math.AngDiff(a, b)
        for xx in (x, -x)
            s, c = GeographicLib.Math.sincosd(x)
            s′, c′ = pymaths.Math.sincosd(x)
            @test s ≈ s′ atol=1e-15
            @test c ≈ c′ atol=1e-15
        end
    end
    let x = rand(), y = rand()
        for (xx, yy) in zip((x, -x), (y, -y))
            @test GeographicLib.Math.atan2d(xx, yy) ≈ pymaths.Math.atan2d(xx, yy) rtol=1e-15
        end
    end
    @test GeographicLib.Math.isfinite(0) && !GeographicLib.Math.isfinite(Inf)
    @test GeographicLib.Math.isnan(NaN) && !GeographicLib.Math.isnan(0)
end
