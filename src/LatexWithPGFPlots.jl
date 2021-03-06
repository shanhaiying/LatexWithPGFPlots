module LatexWithPGFPlots
using PGFPlotsX
import PGFPlots
import PGFPlots: save
using IJulia
import Plots

function __init__()
    IJulia.register_mime(MIME"text/pgf"())
end

# for PGFPlotsX
Base.show(io::IO, ::MIME"text/pgf", p::PGFPlotsX._SHOWABLE) =
    PGFPlotsX.print_tex(io, p)
Base.show(io::IO, ::MIME"text/pgf", p::PGFPlotsX.AxisLike) =
    PGFPlotsX.print_tex(io, TikzPicture(p))
Base.show(io::IO, ::MIME"text/pgf", p::PGFPlotsX.TikzDocument) =
    PGFPlotsX.print_tex(io, p, include_preamble=false)

# for PGFPlots
function Base.show(f::IO, ::MIME"text/pgf", p::PGFPlots.Plottable)
    tmp, _ = mktemp()
    file = "$(tmp).tex"
    save(file, p, include_preamble=false)
    tex = read(file, String)
    print(f, tex)
end

# for Plots
function Plots._ijulia__extra_mime_info!(
        plt::Plots.Plot{Plots.PGFPlotsXBackend},
        out::Dict)
    out["text/pgf"] = sprint(show, MIME("text/pgf"), plt.o.the_plot)
    out
end

function Plots._ijulia__extra_mime_info!(
        plt::Plots.Plot{Plots.PGFPlotsBackend},
        out::Dict)
    out["text/pgf"] = sprint(show, MIME("text/pgf"), PGFPlots.plot(plt.o))
    out
end
end # module
