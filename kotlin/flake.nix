{
  description = "Kotlin development environment";

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
          default = pkgs.stdenv.mkDerivation {
            pname = "myapp";
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.kotlin pkgs.gradle ];
            buildPhase = ''
              gradle build
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp build/libs/*.jar $out/bin/
            '';
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              kotlin
              kotlin-language-server
              gradle
            ];

            shellHook = ''
              echo "Kotlin development environment loaded"
              echo "Kotlin version: $(kotlin -version 2>&1)"
            '';
          };
        });
    };
}
