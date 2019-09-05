using Documenter, GeographicLib

makedocs(
    sitename = "GeographicLib.jl documentation",
    pages = [
        "Home" => "index.md",
        "Examples" => "examples.md",
        "Julia interface" => "julia_funcs.md",
        "Traditional interface" => "traditional_funcs.md"
        ]
    )

deploydocs(
    repo = "github.com/anowacki/GeographicLib.jl.git",
)
