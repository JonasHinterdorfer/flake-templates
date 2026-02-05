{
  description = "PHP development environment";

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
            buildInputs = [ pkgs.php pkgs.phpPackages.composer ];
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
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
              php
              phpPackages.composer
              nodejs  # Often needed for front-end assets
            ];

            shellHook = ''
              echo "PHP development environment loaded"
              echo "PHP version: $(php --version | head -n 1)"
              echo "Composer version: $(composer --version)"
            '';
          };
        });
    };
}
