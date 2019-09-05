using Test
using GeographicLib
using GeographicLib.Accumulators: Accumulator, Add!, Set!, Negate!, Sum

@testset "Accumulators" begin
	@testset "Construction" begin
		let
			a = Accumulator()
			@test a isa Accumulator
			@test a._s == 0.0
			@test a._t == 0.0
			b = Accumulator(a)
			@test a !== b
			@test a == b
			@test a._s == b._s
			@test a._t == b._t
			c = Accumulator(10)
			@test c._s == 10.0
			@test c._t == 0.0
		end
	end

	@testset "Add!" begin
		let a = Accumulator()
			Add!(a, 2)
			@test a._s == 2.0
			@test a._t == -0.0
			Add!(a, 3)
			@test a._s == 5.0
			@test a._t == -0.0
		end
	end

	@testset "Set!" begin
	    let a = Accumulator(-Inf, -Inf), b = Accumulator(3, 4)
	    	Set!(a, b)
	    	@test a == b
	    	Set!(a, 10)
	    	@test a != b
	    	@test a._s == 10.0
	    	@test a._t == 0.0
	    end
	end

	@testset "Negate!" begin
	    let a = Accumulator(2, 3)
	    	Negate!(a)
	    	@test a._s == -2
	    	@test a._t == -3
	    end
	end

	@testset "Sum" begin
	    let a = Accumulator(5)
	    	@test Sum(a) == 5
	    	Add!(a, 2)
	    	@test Sum(a) == 7
	    	Add!(a, -1)
	    	@test Sum(a) == 6
	    end
	end
end