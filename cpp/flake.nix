{
  description = "C++ development environment";

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
            nativeBuildInputs = [ pkgs.cmake pkgs.gcc ];
            buildPhase = ''
              cmake .
              make
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp myapp $out/bin/
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
              gcc
              clang
              cmake
              gnumake
              gdb
              clang-tools
            ];

            shellHook = ''
              echo "C++ development environment loaded"
              echo "G++ version: $(g++ --version | head -n 1)"
              echo "Clang++ version: $(clang++ --version | head -n 1)"
              echo "CMake version: $(cmake --version | head -n 1)"
              
              ${common.lib.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
