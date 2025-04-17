module IO

using TOML
# 他のモジュールで定義される構造体をインポート
using ..Environment: EnvironmentConfig
using ..FlowFields: FlowConfig
using ..Particles: ParticleConfig
using ..Dynamics: DynamicsConfig

export SimulationConfig, OutputConfig, load_config # 他のConfigもexportするかは要検討

"""
    OutputConfig

Output settings defined in FR-OUT.
"""
Base.@kwdef struct OutputConfig
    output_dir::String = "results"
    filename_prefix::String = "snapshot"
    snapshot_interval::Int = 100
end

"""
    SimulationConfig

Structure to hold all simulation parameters loaded from a configuration file.
"""
Base.@kwdef struct SimulationConfig
    env::EnvironmentConfig
    flow::FlowConfig
    particle::ParticleConfig
    dynamics::DynamicsConfig
    output::OutputConfig
end

"""
    load_config(filepath::String)::SimulationConfig

Load simulation parameters from a TOML file.

# Arguments
- `filepath::String`: Path to the TOML configuration file.

# Returns
- `SimulationConfig`: A struct containing all loaded simulation parameters.

# Errors
- Throws an error if the file does not exist.
- Throws an error if required sections or parameters are missing or invalid.
"""
function load_config(filepath::String)::SimulationConfig
    if !isfile(filepath)
        error("Configuration file not found: $(filepath)")
    end

    config_dict = TOML.parsefile(filepath)

    # --- Validate and parse sections ---
    required_sections = ["environment", "flow", "particle", "dynamics", "output"]
    for section in required_sections
        if !haskey(config_dict, section)
            error("Missing required section '[$(section)]' in $(filepath)")
        end
    end

    # --- Parse each section --- 
    env_cfg = try
        # Note: TOML.jl parses arrays as Vector{Any}. We might need explicit conversion for g.
        env_dict = config_dict["environment"]
        if haskey(env_dict, "g") && !(env_dict["g"] isa Vector{<:Real})
             env_dict["g"] = convert(Vector{Float64}, env_dict["g"])
        end
        EnvironmentConfig(; env_dict...)
    catch e
        error("Error parsing [environment] section: $(e)")
    end

    flow_cfg = try
        FlowConfig(; config_dict["flow"]...)
    catch e
        error("Error parsing [flow] section: $(e)")
    end

    particle_cfg = try
        # size_distribution_params needs careful handling if types aren't directly Float64
        # Assuming TOML parser handles Dict{String, Float64} correctly for now.
        ParticleConfig(; config_dict["particle"]...)
    catch e
        error("Error parsing [particle] section: $(e)")
    end

    dynamics_cfg = try
        DynamicsConfig(; config_dict["dynamics"]...)
    catch e
        error("Error parsing [dynamics] section: $(e)")
    end

    output_cfg = try
        OutputConfig(; config_dict["output"]...)
    catch e
        error("Error parsing [output] section: $(e)")
    end

    # --- Construct the main config struct ---
    sim_config = SimulationConfig(
        env = env_cfg,
        flow = flow_cfg,
        particle = particle_cfg,
        dynamics = dynamics_cfg,
        output = output_cfg
    )

    # --- Add validation logic for consistency (e.g., St vs tau_p) ---
    if sim_config.dynamics.inertia_spec == "St" && isnothing(sim_config.dynamics.tau_f)
        error("Fluid characteristic time scale `tau_f` must be provided in [dynamics] when `inertia_spec` is 'St'")
    end
    # Add more validation rules as needed

    return sim_config
end


end # module IO
