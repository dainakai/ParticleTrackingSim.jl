module Environment

export EnvironmentConfig

"""
    EnvironmentConfig

Environment settings defined in FR-ENV.

# Fields
- `Lx::Float64`: Domain size in x-direction.
- `Ly::Float64`: Domain size in y-direction.
- `Lz::Float64`: Domain size in z-direction.
- `Tmax::Float64`: Maximum simulation time.
- `dt::Float64`: Time step size.
- `g::Vector{Float64}`: Gravitational acceleration vector [gx, gy, gz].
- `rho_f::Float64`: Fluid density.
- `mu_f::Float64`: Fluid dynamic viscosity.
- `random_seed::Int`: Seed for random number generation.
"""
Base.@kwdef struct EnvironmentConfig
    Lx::Float64 = 1.0
    Ly::Float64 = 1.0
    Lz::Float64 = 1.0
    Tmax::Float64 = 10.0
    dt::Float64 = 0.01
    g::Vector{Float64} = [0.0, 0.0, -9.81]
    rho_f::Float64 = 1.0
    mu_f::Float64 = 0.01
    random_seed::Int = 1234
end

# Placeholder for environment-related functionalities

end # module Environment
