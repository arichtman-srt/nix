{
  description = "A Nix-flake-based C# development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          dotnet-sdk_6
          omnisharp-roslyn
          mono
          terraform
          awscli2
          hadolint
          pre-commit
        ];
        shellHook = ''
          export SKIP=terragrunt_fmt,check-github-actions,copy-repeated-files
          pre-commit install --install-hooks
        '';
      };
    });
}
