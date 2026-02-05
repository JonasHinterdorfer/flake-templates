{
  description = "Python development environment with automatic venv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      common = import ../common.nix;
      forAllSystems = common.forAllSystems nixpkgs;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.python3Packages.buildPythonApplication {
            pname = "myapp";
            version = "0.1.0";
            src = ./.;
            propagatedBuildInputs = with pkgs.python3Packages; [
              # Add your Python dependencies here
            ];
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              python3
              python3Packages.pip
              python3Packages.virtualenv
              python3Packages.setuptools
              python3Packages.wheel
              pyright
              ruff
              black
            ];

            shellHook = ''
              # Create venv if it doesn't exist
              if [ ! -d .venv ]; then
                echo "Creating Python virtual environment..."
                python -m venv .venv
              fi
              
              # Activate venv
              source .venv/bin/activate
              
              # Upgrade pip
              pip install --upgrade pip > /dev/null 2>&1
              
              echo "Python development environment loaded"
              echo "Python version: $(python --version)"
              echo "Virtual environment: .venv (activated)"
              echo ""
              echo "To install dependencies, run: pip install -r requirements.txt"
              
              ${common.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
