{
  # Common library functions for all templates
  
  # Interactive direnv prompt that can be used in any shellHook
  interactiveDirenvPrompt = ''
    # Check if direnv is installed and not already allowed
    if command -v direnv > /dev/null 2>&1; then
      if [ ! -f .envrc.allowed ]; then
        echo ""
        echo "Would you like to enable automatic environment loading with direnv?"
        echo -n "This will run: direnv allow (y/N): "
        read -r response
        if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
          direnv allow
          touch .envrc.allowed
          echo "✓ direnv enabled! Environment will load automatically in new shells."
        fi
      fi
    fi
  '';
  
  # Common system architectures
  systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  
  # Helper to generate attributes for all systems
  forAllSystems = nixpkgs: f: nixpkgs.lib.genAttrs systems (system: f system);
}
