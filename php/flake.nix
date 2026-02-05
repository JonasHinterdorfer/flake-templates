{
  description = "PHP development environment";

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
              
              ${common.lib.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
