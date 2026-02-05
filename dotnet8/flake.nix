{
  description = ".NET 8 development environment";

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
            dotnet-sdk = pkgs.dotnet-sdk_8;
            dotnet-runtime = pkgs.dotnet-runtime_8;
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              dotnet-sdk_8
              omnisharp-roslyn
            ];

            shellHook = ''
              echo ".NET 8 development environment loaded"
              echo ".NET version: $(dotnet --version)"
            '';
          };
        });
    };
}
