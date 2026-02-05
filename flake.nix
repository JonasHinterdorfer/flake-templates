{
  description = "A collection of Nix flake templates for various programming languages";

  outputs = { self }: {
    templates = {
      go = {
        path = ./go;
        description = "Go development environment with latest Go toolchain";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      rust = {
        path = ./rust;
        description = "Rust development environment with cargo, rustc, and rust-analyzer";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      node-angular = {
        path = ./node-angular;
        description = "Node.js with Angular CLI and TypeScript support";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      java = {
        path = ./java;
        description = "Java development with JDK and Maven/Gradle";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      kotlin = {
        path = ./kotlin;
        description = "Kotlin development environment with Kotlin compiler";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      dotnet10 = {
        path = ./dotnet10;
        description = ".NET 10 development environment";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      dotnet9 = {
        path = ./dotnet9;
        description = ".NET 9 development environment";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      dotnet8 = {
        path = ./dotnet8;
        description = ".NET 8 development environment";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      c = {
        path = ./c;
        description = "C development with gcc, cmake, and clang";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      cpp = {
        path = ./cpp;
        description = "C++ development with g++, cmake, and clang";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      fsharp = {
        path = ./fsharp;
        description = "F# development environment";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };

      php = {
        path = ./php;
        description = "PHP development environment with composer";
        welcomeText = ''
          # Setup Complete!
          
          To enable automatic environment loading, run:
            direnv allow
          
          Would you like to run this now? (This will activate the development environment)
        '';
      };
    };

    defaultTemplate = self.templates.go;
  };
}
