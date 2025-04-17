module FlowFields

export FlowConfig

"""
    FlowConfig

Flow field settings defined in FR-FLOW.

# Fields
- `type::String`: Type of the flow field (e.g., "homogeneous_isotropic_turbulence", "simple_shear", "abc_flow", "taylor_green").
- `resolution::Union{Int, Nothing}`: Resolution for turbulence generation (if applicable).
- `spectrum_shape::Union{String, Nothing}`: Spectrum shape for turbulence (e.g., "von_karman_paoletti", if applicable).
- `shear_rate::Union{Float64, Nothing}`: Shear rate for simple shear flow.
- `abc_A::Union{Float64, Nothing}`: Parameter A for ABC flow.
- `abc_B::Union{Float64, Nothing}`: Parameter B for ABC flow.
- `abc_C::Union{Float64, Nothing}`: Parameter C for ABC flow.
- `tg_k0::Union{Float64, Nothing}`: Wavenumber for Taylor-Green vortex.
- `time_varying_mode::Union{String, Nothing}`: Mode of time variation (e.g., "frozen", "evolving").
"""
Base.@kwdef struct FlowConfig
    type::String = "homogeneous_isotropic_turbulence"
    resolution::Union{Int, Nothing} = 64
    spectrum_shape::Union{String, Nothing} = "von_karman_paoletti"
    shear_rate::Union{Float64, Nothing} = nothing
    abc_A::Union{Float64, Nothing} = nothing
    abc_B::Union{Float64, Nothing} = nothing
    abc_C::Union{Float64, Nothing} = nothing
    tg_k0::Union{Float64, Nothing} = nothing
    time_varying_mode::Union{String, Nothing} = "frozen"
end

# Placeholder for flow field generation

end # module FlowFields
