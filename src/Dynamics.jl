module Dynamics

export DynamicsConfig

"""
    DynamicsConfig

Particle dynamics settings defined in FR-DYN.

# Fields
- `inertia_spec::String`: How particle inertia is specified ('tau_p' or 'St').
- `tau_p::Union{Float64, Nothing}`: Particle relaxation time (if inertia_spec is 'tau_p').
- `St::Union{Float64, Nothing}`: Stokes number (if inertia_spec is 'St').
- `tau_f::Union{Float64, Nothing}`: Fluid characteristic time scale (required if inertia_spec is 'St').
- `interpolation_method::String`: Method for interpolating fluid velocity at particle position (e.g., "linear", "cubic").
- `integration_method::String`: Time integration method for particle trajectory (e.g., "euler_maruyama", "runge_kutta4").
"""
Base.@kwdef struct DynamicsConfig
    inertia_spec::String = "tau_p"
    tau_p::Union{Float64, Nothing} = 0.1
    St::Union{Float64, Nothing} = nothing
    tau_f::Union{Float64, Nothing} = nothing # Should be provided or calculated if St is used
    interpolation_method::String = "linear"
    integration_method::String = "euler_maruyama"
end


# Placeholder for particle dynamics and time integration

end # module Dynamics
