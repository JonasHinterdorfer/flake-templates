{
  description = "Go development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      common = import ./common.nix;
      forAllSystems = common.forAllSystems nixpkgs;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "myapp";
            version = "0.1.0";
            src = ./.;
            vendorHash = null; # Set to the correct hash after first build, or use vendorHash = null for no dependencies
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go
              gopls
              go-tools
              gotools
              golangci-lint
              delve
            ];

            shellHook = ''
              echo "Go development environment loaded"
              echo "Go version: $(go version)"
              
              ${common.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
