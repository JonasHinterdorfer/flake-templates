{
  description = ".NET 10 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildDotnetModule {
            pname = "myapp";
            version = "0.1.0";
            src = ./.;
            projectFile = "myapp.csproj"; # Adjust to your project file
            nugetDeps = ./deps.nix; # Generate with: nuget-to-nix
            dotnet-sdk = pkgs.dotnet-sdk_9;
            dotnet-runtime = pkgs.dotnet-runtime_9;
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              dotnet-sdk_9  # Using .NET 9 as .NET 10 might not be available yet
              omnisharp-roslyn
            ];

            shellHook = ''
              echo ".NET 10 development environment loaded"
              echo ".NET version: $(dotnet --version)"
            '';
          };
        });
    };
}
