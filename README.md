# Nix Flake Templates

A collection of Nix flake templates for various programming languages and development environments.

## Available Templates

This repository provides ready-to-use Nix flake templates for the following languages and frameworks:

- **go** (default) - Go development environment with latest toolchain, gopls, linters, and debugger
- **rust** - Rust development with cargo, rustc, rust-analyzer, and clippy
- **python** - Python development with automatic venv creation, pip, pyright, ruff, and black
- **node-angular** - Node.js with Angular CLI and TypeScript support
- **java** - Java development with JDK, Maven, and Gradle
- **kotlin** - Kotlin development environment with compiler and language server
- **dotnet10** - .NET 10 development environment
- **dotnet9** - .NET 9 development environment
- **dotnet8** - .NET 8 development environment
- **c** - C development with gcc, cmake, clang, and gdb
- **cpp** - C++ development with g++, cmake, clang, and gdb
- **fsharp** - F# development environment
- **php** - PHP development with composer

## Usage

### Initialize a New Project

To use a template, run:

```bash
nix flake init -t github:JonasHinterdorfer/flake-templates#<template-name>
```

For example, to create a new Go project:

```bash
nix flake init -t github:JonasHinterdorfer/flake-templates#go
```

Or use the default template (go):

```bash
nix flake init -t github:JonasHinterdorfer/flake-templates
```

### Enable direnv (Recommended)

Each template includes a `.envrc` file for automatic environment activation with direnv:

1. Install direnv: https://direnv.net/docs/installation.html
2. After initializing the template, run:
   ```bash
   direnv allow
   ```

This will automatically load the development environment whenever you enter the project directory.

### Development Shell

Enter the development environment manually with:

```bash
nix develop
```

This will provide all the tools and dependencies specified in the template's `flake.nix`.

### Building Packages

Each template includes a `packages` output that allows you to build your project as a Nix package:

```bash
nix build
```

The built artifacts will be available in the `./result` directory.

You can also run the package directly without building:

```bash
nix run
```

## Template Structure

Each template includes:

- **flake.nix** - Nix flake configuration with:
  - `devShells.default` - Development environment with language tooling
  - `packages.default` - Build configuration for the project
- **.envrc** - direnv configuration for automatic environment loading
- **.gitignore** - Language-specific gitignore patterns

## Customization

After initializing a template, you can customize the `flake.nix` file to:

- Add or remove development tools in the `devShells.default` section
- Modify build settings in the `packages.default` section
- Add additional outputs (apps, checks, etc.)

### Package Build Configuration

Each template includes a basic build configuration. You'll need to adjust the following based on your project:

- **Go**: Update `vendorHash` after running `go mod vendor`
- **Rust**: Ensure `Cargo.lock` exists in your project
- **Python**: The venv is automatically created in `.venv/` and activated. Install dependencies with `pip install -r requirements.txt`
- **Node/Angular**: Set correct `npmDepsHash` after first build
- **.NET**: Adjust `projectFile` to match your .csproj/.fsproj file and run `nuget-to-nix` to generate `deps.nix`
- **Java/Kotlin**: Adjust build commands and output paths
- **C/C++**: Modify CMake commands and output binary names
- **PHP**: Customize install phase based on your application structure

## Requirements

- Nix with flakes enabled
- Optionally: direnv for automatic environment loading

To enable flakes, add to your `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

## Examples

### Create a new Rust project

```bash
mkdir my-rust-project
cd my-rust-project
nix flake init -t github:JonasHinterdorfer/flake-templates#rust
direnv allow
cargo init
nix develop
```

### Create a new Python project with venv

```bash
mkdir my-python-project
cd my-python-project
nix flake init -t github:JonasHinterdorfer/flake-templates#python
direnv allow
# The venv will be automatically created and activated
pip install requests  # Example: install a package
```

### Create a new Java project

```bash
mkdir my-java-project
cd my-java-project
nix flake init -t github:JonasHinterdorfer/flake-templates#java
direnv allow
nix develop
```

## Contributing

Contributions are welcome! Feel free to open issues or pull requests to improve the templates or add new ones.

## License

See [LICENSE](LICENSE) file for details.
