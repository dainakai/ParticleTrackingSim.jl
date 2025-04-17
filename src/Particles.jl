module Particles

export ParticleConfig

"""
    ParticleConfig

Particle settings defined in FR-PART.

# Fields
- `Np::Int`: Total number of particles.
- `rho_p::Float64`: Particle density.
- `size_distribution_type::String`: Type of particle size distribution (e.g., "monodisperse", "lognormal", "uniform").
- `size_distribution_params::Dict{String, Float64}`: Parameters for the size distribution.
    - For "monodisperse": `{"dp": value}`
    - For "lognormal": `{"mean_dp": value, "std_dev_log_dp": value}`
    - For "uniform": `{"min_dp": value, "max_dp": value}`
"""
Base.@kwdef struct ParticleConfig
    Np::Int = 1000
    rho_p::Float64 = 2000.0
    size_distribution_type::String = "monodisperse"
    size_distribution_params::Dict{String, Float64} = Dict("dp" => 1e-5) # Example: 10 micron diameter
end


# Placeholder for particle data structures and initialization

end # module Particles
