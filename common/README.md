# Common Library for Flake Templates

This flake provides common utility functions used by all template flakes in this repository.

## Exported Functions

### `lib.systems`
A list of common system architectures:
- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

### `lib.forAllSystems`
A helper function to generate attributes for all supported systems.

**Usage:**
```nix
forAllSystems = common.lib.forAllSystems nixpkgs;

# Then use it like:
packages = forAllSystems (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    default = pkgs.hello;
  });
```

### `lib.interactiveDirenvPrompt`
An interactive prompt that asks users if they want to enable direnv. This version is fixed to work properly in shellHooks.

**Features:**
- Reads input from `/dev/tty` instead of stdin (works in shellHooks)
- Checks if running in an interactive shell
- Includes a 10-second timeout to avoid hanging
- Provides fallback messages for non-interactive environments
- Only prompts once (uses `.envrc.allowed` marker file)

**Usage in shellHook:**
```nix
shellHook = ''
  echo "Development environment loaded"
  
  ${common.lib.interactiveDirenvPrompt}
'';
```

## How to Use in Templates

### Main Repository Flake
```nix
{
  inputs = {
    common.url = "path:./common";
  };
  
  outputs = { self, common }: {
    # Your template definitions
  };
}
```

### Individual Template Flakes
```nix
{
  description = "My development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    common.url = "github:JonasHinterdorfer/flake-templates?dir=common";
  };

  outputs = { self, nixpkgs, common }:
    let
      forAllSystems = common.lib.forAllSystems nixpkgs;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [ /* your packages */ ];

            shellHook = ''
              echo "Environment loaded"
              
              ${common.lib.interactiveDirenvPrompt}
            '';
          };
        });
    };
}
```

## Why This Architecture?

Previously, templates imported `../common.nix` which caused the error:
```
access to absolute path is forbidden in pure evaluation mode
```

By creating a separate flake for common code:
1. ✅ No more absolute path errors
2. ✅ Templates can reference common as a flake input
3. ✅ Better modularity and reusability
4. ✅ Follows Nix flake best practices
