using ParticleTrackingSim
using Test
using TOML

# テスト用設定ファイルのパス
const CONFIG_PATH = joinpath(@__DIR__, "config.toml")
const TEMP_DIR = mktempdir()

@testset "ParticleTrackingSim.jl Tests" begin

    @testset "Config Loading" begin
        # 1. Test loading a valid config file
        @testset "Valid Config" begin
            cfg = load_config(CONFIG_PATH)

            # Environment checks
            @test cfg.env.Lx == 2.0
            @test cfg.env.Ly == 2.0
            @test cfg.env.Lz == 2.0
            @test cfg.env.Tmax == 5.0
            @test cfg.env.dt == 0.005
            @test cfg.env.g == [0.0, 0.0, -9.81]
            @test cfg.env.rho_f == 1.2
            @test cfg.env.mu_f == 1.8e-5
            @test cfg.env.random_seed == 42

            # Flow checks
            @test cfg.flow.type == "simple_shear"
            @test cfg.flow.shear_rate == 10.0
            @test isnothing(cfg.flow.resolution) # Check default/unused value

            # Particle checks
            @test cfg.particle.Np == 500
            @test cfg.particle.rho_p == 1500.0
            @test cfg.particle.size_distribution_type == "lognormal"
            @test cfg.particle.size_distribution_params == Dict("mean_dp" => 5e-5, "std_dev_log_dp" => 0.2)

            # Dynamics checks
            @test cfg.dynamics.inertia_spec == "tau_p"
            @test cfg.dynamics.tau_p == 0.05
            @test isnothing(cfg.dynamics.St) # Check default/unused value
            @test cfg.dynamics.interpolation_method == "linear"
            @test cfg.dynamics.integration_method == "euler_maruyama"

            # Output checks
            @test cfg.output.output_dir == "test_output"
            @test cfg.output.filename_prefix == "test_snap"
            @test cfg.output.snapshot_interval == 50
        end

        # 2. Test missing required section
        @testset "Missing Section" begin
            invalid_config_content = """
            [environment]
            Lx = 1.0
            # ... other env params ...

            [flow] # Missing particle, dynamics, output
            type = "frozen"
            """
            invalid_config_path = joinpath(TEMP_DIR, "missing_section.toml")
            write(invalid_config_path, invalid_config_content)
            @test_throws ErrorException("Missing required section '[particle]' in $(invalid_config_path)") load_config(invalid_config_path)
        end

        # 3. Test missing required parameter (St vs tau_f validation)
        @testset "Missing Parameter (St/tau_f)" begin
            invalid_config_content = """
            [environment]
            Lx=1; Ly=1; Lz=1; Tmax=1; dt=0.1; g=[0,0,-9.81]; rho_f=1; mu_f=0.1; random_seed=1
            [flow]
            type="frozen"
            [particle]
            Np=10; rho_p=1000; size_distribution_type="monodisperse"; size_distribution_params={"dp"=1e-4}
            [dynamics]
            inertia_spec = "St" 
            St = 0.5 # tau_f is missing!
            interpolation_method = "linear"
            integration_method = "euler_maruyama"
            [output]
            output_dir="out"; filename_prefix="snap"; snapshot_interval=10
            """
            invalid_config_path = joinpath(TEMP_DIR, "missing_tau_f.toml")
            write(invalid_config_path, invalid_config_content)
            @test_throws ErrorException("Fluid characteristic time scale `tau_f` must be provided in [dynamics] when `inertia_spec` is 'St'") load_config(invalid_config_path)
        end

        # 4. Test non-existent file
        @testset "Non-existent File" begin
            non_existent_path = joinpath(TEMP_DIR, "does_not_exist.toml")
            @test_throws ErrorException("Configuration file not found: $(non_existent_path)") load_config(non_existent_path)
        end

        # 5. Test invalid type (e.g., string instead of number)
        @testset "Invalid Type" begin
             invalid_config_content = """
            [environment]
            Lx = "not_a_number" # Invalid type
            Ly=1; Lz=1; Tmax=1; dt=0.1; g=[0,0,-9.81]; rho_f=1; mu_f=0.1; random_seed=1
            [flow]
            type="frozen"
            [particle]
            Np=10; rho_p=1000; size_distribution_type="monodisperse"; size_distribution_params={"dp"=1e-4}
            [dynamics]
            inertia_spec = "tau_p"; tau_p=0.1; interpolation_method = "linear"; integration_method = "euler_maruyama"
            [output]
            output_dir="out"; filename_prefix="snap"; snapshot_interval=10
            """
            invalid_config_path = joinpath(TEMP_DIR, "invalid_type.toml")
            write(invalid_config_path, invalid_config_content)
            # TOML.jl might throw a specific error, or the struct conversion will fail.
            # Testing for a generic ErrorException related to parsing is safer.
            @test_throws ErrorException("Error parsing [environment] section: MethodError(no method matching Float64(::String)) or similar") try load_config(invalid_config_path) catch e; throw(ErrorException("Error parsing [environment] section: $(e)")) end 
            # A more specific error message might be needed depending on TOML.jl or struct conversion behavior
        end

    end

    # Add other test sets for different modules/functionalities later
    # @testset "Dynamics Module" begin ... end
    # @testset "Particle Module" begin ... end

end

# Clean up temporary directory
rm(TEMP_DIR, recursive=true) 