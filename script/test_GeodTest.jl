import Pkg
Pkg.activate(@__DIR__)

using GeographicLib
using PyCall

include("GLWrapper.jl")
import .GLWrapper

not_equal(x, y; rtol=1e-5, atol=1e-5) = !(((x == 0 || y == 0) && ≈(x, y, atol=atol))
                                                              || ≈(x, y, rtol=rtol))

"""
    runtest(; verbose=true, python=false, rtol=1e-35, atol=1e-5) -> inputs, wrong_lines, wrong_lines_c, wrong_lines_python

Compare the output of GeographicLib.jl to the reference forward calculations
of Charles F.F. Karney (2010).

Returns the set of `inputs` taken from the reference data, and a vector of 'errors'
(mismatches between the reference and calculated values)
from the forward calculation, both using this package, and those returned by
the geographiclib functions as exposed in the C library `Proj`.

This function assumes you have the `libproj` library installed and uses the `GLWrapper`
module in the same directory as this file.

If `verbose` is `true`, then errors are printed out as the tests are run.  If `python`
is true, then the Python module `geographiclib` is also compared to the test data.
Note that calling the Python functions 500,000 times as is done here is quite slow
and will take several minutes.

### References

- Karney, C. F. F. (2010). Test set for geodesics [Data set].
  Zenodo. http://doi.org/10.5281/zenodo.32156
"""
function runtest(;
    verbose=true, python=false, rtol=1e-5, atol=1e-5,
    geod_test_file=joinpath(@__DIR__, "GeodTest.dat")
)
    if !isfile(geod_test_file)
        @info("Downloading 83 MB file to $geod_test_file")
        download("https://zenodo.org/record/32156/files/GeodTest.dat?download=1",
            geod_test_file)
    end
    a = 6378137
    flat = 1/298.257223563
    test_geod = Geodesic(a, flat)
    c_test_geod = GLWrapper.GeodGeodesic(a, flat)
    inputs = []
    wrong_lines = []
    c_wrong_lines = []
    py_wrong_lines = []
    if python
        geodesic = PyCall.pyimport("geographiclib.geodesic")
        py_test_geod = geodesic.Geodesic(a, flat)
    end
    open(geod_test_file, "r") do file
        i = 1
        while ! eof(file)
            lat1, lon1, azi1, lat2, lon2, azi2, s12, a12, m12, S12 =
                readline(file) |> split .|> x->parse(Float64, x)
            r_true = (lat1=lat1, lon1=lon1, azi1=azi1, lat2=lat2, lon2=lon2,
                      azi2=azi2, s12=s12, a12=a12, m12=m12, S12=S12)  
            push!(inputs, r_true)
            r_test = GeographicLib.Direct(test_geod, lat1, lon1, azi1, s12,
                                          GeographicLib.Geodesics.ALL)
            r_test_c = GLWrapper.geod_gendirect(c_test_geod, lat1, lon1, azi1, s12)
            if python
                r_test_py = py_test_geod.Direct(lat1, lon1, azi1, s12, py_test_geod.ALL)
            end
            for f in fieldnames(typeof(r_true))
                v_true = getfield(r_true, f)
                v_test = getfield(r_test, f)
                v_test_c = getfield(r_test_c, f)
                if v_test !== nothing
                    if not_equal(v_true, v_test, rtol=rtol, atol=atol)
                        verbose && println("Line $i: $f: $v_true (true) ≠ $v_test")
                        push!(wrong_lines, (i=i, value=f, truth=v_true, test=v_test))
                    end
                    if not_equal(v_true, v_test_c, rtol=rtol, atol=atol)
                        push!(c_wrong_lines, (i=i, value=f, truth=v_true, test=v_test_c))
                    end
                end
                if python
                    v_test_py = r_test_py["$f"]
                    if not_equal(v_true, v_test_py, rtol=rtol, atol=atol)
                        push!(py_wrong_lines, (i=i, value=f, truth=v_true, test=v_test_py))
                    end
                end
            end
            i += 1
        end
    end
    errors = length(unique(w.i for w in wrong_lines))
    errors_c = length(unique(w.i for w in c_wrong_lines))
    errors_python = length(unique(w.i for w in py_wrong_lines))
    @info("Total Julia error lines:  $errors")
    @info("Total C error lines:      $errors_c")
    if python
        @info("Total Python error lines: $errors_python")
    end
    (; inputs, wrong_lines, c_wrong_lines, py_wrong_lines)
end

!isinteractive() && abspath(PROGRAM_FILE) == abspath(@__FILE__) && runtest()
