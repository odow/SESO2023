import JuMP
import SDDP
import Literate

tutorials = Dict(
    JuMP => [
        "getting_started" => "docs/src/tutorials/getting_started/getting_started_with_julia.jl",
        "knapsack" => "docs/src/tutorials/linear/knapsack.jl",
        "diet" => "docs/src/tutorials/linear/diet.jl",
        "rocket" => "docs/src/tutorials/nonlinear/rocket_control.jl",
        "multi_objective" => "docs/src/tutorials/linear/multi_objective_knapsack.jl",
        "cutting_stock" => "docs/src/tutorials/algorithms/cutting_stock_column_generation.jl",
        "two_stage_stochastic" => "docs/src/tutorials/applications/two_stage_stochastic.jl",
    ],
    SDDP => [
        "mdps" => "docs/src/tutorial/mdps.jl",
        "milk_producer" => "docs/src/tutorial/example_milk_producer.jl",
        "hydro_thermal" => "docs/src/tutorial/example_reservoir.jl",
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
    return str
end

for (pkg, data) in tutorials
    root = dirname(dirname(pathof(pkg)))
    for (output, input_filename) in data
        filename =
        Literate.notebook(
            joinpath(root, input_filename),
            @__DIR__;
            nname = output,
            execute = false,
            preprocess = admonitions,
            credit = false,
        )
    end
end
