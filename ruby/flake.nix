{
  description = "A Nix-flake-based Ruby development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
          pre-commit
          ruby_3_2
          rubyPackages_3_2.rubocop
          #bundler
        ];
        shellHook = ''
          export SKIP=terragrunt_fmt,check-github-actions,copy-repeated-files
          pre-commit install --install-hooks
        '';
      };
    });
}
