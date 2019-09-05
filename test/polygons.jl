using Test
using GeographicLib
import GeographicLib.Polygons
using GeographicLib.Polygons: Polygon

@testset "Polygons" begin
    @testset "Construction" begin
	    # Polygons
        let p = Polygon(GeographicLib.WGS84)
            @test p isa Polygon
            @test p.earth == GeographicLib.WGS84
            @test p.polyline == false
            @test p.num == 0
        end
        # Polylines
        let p = Polygon(Geodesic(1, 0), true)
            @test p.polyline == true
            add_point!.(p, rand(3), rand(3))
            prop = properties(p)
            @test !isnan(prop.perimeter)
            @test isnan(prop.area)
        end
        # Multiple-point constructor
        let n = 100, lons = 360 .* rand(n), lats = 180 .* rand(n) .- 90
        	p = Polygon(lons, lats)
        	@test p == Polygon(GeographicLib.WGS84, lons, lats)
        	p′ = Polygon()
        	for (lon, lat) in zip(lons, lats)
        		add_point!(p′, lon, lat)
        	end
        	@test p == p′
        end
    end

	@testset "AddPoint!" begin
	    let p = Polygon(Geodesic(1, 0)), lat = 180rand()-90, lon = 360rand()
	    	Polygons.AddPoint!(p, lat, lon)
	    	@test p.num == 1
	    	@test p.lat1 == lat
	    	@test p.lon1 == lon
	    	Polygons.AddPoint!(p, -1, -2)
	    	@test p.num == 2
	    	@test p.lat1 == -1
	    	@test p.lon1 == -2
	    end
	end

	@testset "AddEdge!" begin
	    let g = Geodesic(1, 0), p = Polygon(g), lat = 180rand() - 90, lon = 360rand(),
		    	azi = 360rand(), dist = rand()
	    	@test_throws ErrorException Polygons.AddEdge!(p, 1, 1)
	    	Polygons.AddPoint!(p, lat, lon)
	    	Polygons.AddEdge!(p, azi, dist)
	    	result = forward(g, lon, lat, azi, dist)
	    	@test p.num == 2
	    	@test mod(p.lat1, 360) ≈ mod(result.lat, 360)
	    	@test mod(p.lon1, 360) ≈ mod(result.lon, 360)
	    end
	end

	@testset "TestPoint" begin
	    let p = Polygon(GeographicLib.WGS84), n = 100,
		    	lats = 180 .* rand(n) .- 90, lons = 360 .* rand(n)
	    	for i in 1:(n-1)
	    		Polygons.AddPoint!(p, lats[i], lons[i])
	    	end
	    	num, perim, area = Polygons.TestPoint(p, lats[end], lons[end])
	    	Polygons.AddPoint!(p, lats[end], lons[end])
	    	num′, perim′, area′ = Polygons.Compute(p)
	    	@test num == num′
	    	@test perim ≈ perim′
	    	@test area ≈ area′
	    end
	end

    @testset "Compute" begin
	    # Test taken from https://geographiclib.sourceforge.io/html/python/examples.html#measuring-areas
	    # N.B.: Although not stated, the Python example above actually uses WGS84,
	    # rather than the ellipsoid previously created.
        let p = Polygon(GeographicLib.WGS84)
            antarctica = [
                [-63.1, -58], [-72.9, -74], [-71.9,-102], [-74.9,-102], [-74.3,-131],
                [-77.5,-163], [-77.4, 163], [-71.7, 172], [-65.9, 140], [-65.7, 113],
                [-66.6,  88], [-66.9,  59], [-69.8,  25], [-70.0,  -4], [-71.0, -14],
                [-77.3, -33], [-77.9, -46], [-74.7, -61]]
            for pnt in antarctica
                Polygons.AddPoint!(p, pnt...)
            end
            num, perim, area = Polygons.Compute(p)
            @test num == length(antarctica)
            @test round(perim, digits=3) ≈ 16831067.893
            @test round(area, digits=3) ≈ 13662703680020.1
        end
    end
end