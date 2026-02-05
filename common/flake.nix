{
  description = "Common library functions for flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    lib = {
      # Common system architectures
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper to generate attributes for all systems
      # Usage: forAllSystems nixpkgs (system: { ... })
      forAllSystems = nixpkgs: f: 
        nixpkgs.lib.genAttrs self.lib.systems (system: f system);

      # Interactive direnv prompt that can be used in any shellHook
      # This version is fixed to work in shellHooks without attached stdin
      # by reading from /dev/tty instead
      interactiveDirenvPrompt = ''
        # Check if direnv is installed and not already allowed
        if command -v direnv > /dev/null 2>&1; then
          if [ ! -f .envrc.allowed ]; then
            echo ""
            echo "Would you like to enable automatic environment loading with direnv?"
            echo -n "This will run: direnv allow (y/N): "
            
            # Try to read from /dev/tty if available (for interactive shells)
            # This works even in shellHooks which don't have stdin attached
            if [ -t 0 ] && [ -r /dev/tty ]; then
              # We're in an interactive shell with /dev/tty available
              # Use timeout to avoid hanging indefinitely
              if read -r -t 10 response < /dev/tty 2>/dev/null; then
                if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
                  direnv allow
                  touch .envrc.allowed
                  echo "✓ direnv enabled! Environment will load automatically in new shells."
                else
                  echo "Skipped. You can run 'direnv allow' manually later."
                fi
              else
                echo ""
                echo "No response received. You can run 'direnv allow' manually to enable."
              fi
            else
              # Not interactive or /dev/tty not available
              echo ""
              echo "Run 'direnv allow' manually to enable automatic environment loading."
            fi
          fi
        fi
      '';
    };
  };
}
