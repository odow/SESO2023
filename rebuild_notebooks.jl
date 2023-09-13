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
        "11_mdps" => "docs/src/tutorial/mdps.jl",
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
