import JuMP
import SDDP
import Literate

tutorials = Dict(
    JuMP => [
        "00_getting_started" => "docs/src/tutorials/getting_started/getting_started_with_julia.jl",
        "01_knapsack" => "docs/src/tutorials/linear/knapsack.jl",
        "02_diet" => "docs/src/tutorials/linear/diet.jl",
        "03_rocket" => "docs/src/tutorials/nonlinear/rocket_control.jl",
        "04_multi_objective" => "docs/src/tutorials/linear/multi_objective_knapsack.jl",
        "05_cutting_stock" => "docs/src/tutorials/algorithms/cutting_stock_column_generation.jl",
        "06_design_patterns_for_larger_models" => "docs/src/tutorials/getting_started/design_patterns_for_larger_models.jl",
        "10_two_stage_stochastic" => "docs/src/tutorials/applications/two_stage_stochastic.jl",
        ],
    SDDP => [
        "11_newsvendor" => "docs/src/tutorial/example_newsvendor.jl",
        "12_hydro_thermal" => "docs/src/tutorial/example_reservoir.jl",
        "13_milk_producer" => "docs/src/tutorial/example_milk_producer.jl",
    ],
)

function admonition(str, name)
    return replace(str, "!!! $(lowercase(name))" => "**$name**")
end

function admonitions(str)
    str = admonition(str, "Note")
    str = admonition(str, "Tip")
    str = admonition(str, "Warning")
    str = admonition(str, "Info")
    str = replace(str, "  #hide" => "")
    return str
end

rm(joinpath(@__DIR__, "notebooks"); force = true, recursive = true)
for (pkg, data) in tutorials
    root = dirname(dirname(pathof(pkg)))
    for (output, input_filename) in data
        Literate.notebook(
            joinpath(root, input_filename),
            joinpath(@__DIR__, "notebooks");
            name = output,
            execute = false,
            preprocess = admonitions,
            credit = false,
        )
    end
end

# concat one big notebook for colab

function concat_for_colab(output, inputs)
    dir = mktempdir()
    filename = joinpath(dir, "uber_tutorial.jl")
    open(filename, "a") do io
        println(io, """
        # Run this cell once

        %%shell
        set -e
        wget -nv https://raw.githubusercontent.com/odow/SESO2023/main/install_colab.sh -O /tmp/install_colab.sh
        bash /tmp/install_colab.sh  # Takes ~ 2 minutes

        # Then refresh the page... and run this cell once

        import Downloads, Pkg
        Downloads.download("https://raw.githubusercontent.com/odow/SESO2023/main/Project.toml", "/tmp/Project.toml")
        Pkg.activate("/tmp/Project.toml")
        Pkg.instantiate()  # Can take ~ 7 minutes
        """)
        for file in [
            joinpath(dirname(dirname(pathof(pkg))), input_filename)
            for (pkg, data) in tutorials
            for (output, input_filename) in data
            if any(s -> startswith(output, s), inputs)
    ]
            write(io, read(file, String))
            write(io, "\n\n")
        end
    end
    Literate.notebook(
        filename,
        joinpath(@__DIR__, "notebooks");
        name = output,
        execute = false,
        preprocess = admonitions,
        credit = false,
    )
end

concat_for_colab("colab_julia_days", ["01", "02", "03", "04", "05", "06"])
concat_for_colab("colab_seso", ["1", "01", "02"])
