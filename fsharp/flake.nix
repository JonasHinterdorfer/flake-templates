{
  description = "F# development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    common.url = "github:JonasHinterdorfer/flake-templates?dir=common";
  };

  outputs = { self, nixpkgs, common }:
    let
      forAllSystems = common.lib.forAllSystems nixpkgs;
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
            projectFile = "myapp.fsproj"; # Adjust to your project file
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
              fsautocomplete
            ];

            shellHook = ''
              echo "F# development environment loaded"
              echo ".NET version: $(dotnet --version)"
              echo "F# compiler available via: dotnet fsi"
              
              ${common.lib.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
