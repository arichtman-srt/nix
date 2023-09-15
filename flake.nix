{
  description = "Templates for Nix environments";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils = {
      url = "github:numtide/flake-utils";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    utils,
    self,
    poetry2nix,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        pkgs = import nixpkgs {
          inherit system;
        };
        poetryEnv = mkPoetryEnv {
          projectDir = ./.;
        };
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [poetryEnv terraform terragrunt awscli2 poetry graphviz];
            # https://github.com/pre-commit/pre-commit/issues/432
            shellHook = ''
              export SKIP=terraform_fmt,terragrunt_fmt,check-renovate
              pre-commit install --install-hooks
            '';
          };

        templates = {
          pe = {
            path = ./pe;
            description = "Platform Engineering environment";
            welcomeText = ''
              # SilverRailTech Platform Engineering Environment

              ## Inclusions

              - Pre-commit hooks
              - Nix flake development environment
              - Python + Poetry project
              - Git attributes
              - Git ignore
              - Direnv activation file

              glhf
            '';
          };
        };
      }
    );
}
