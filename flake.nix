{
  description = "Templates for Nix environments";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils = {
      url = "github:numtide/flake-utils";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
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
        pkgs = import nixpkgs {
          inherit system;
          overlays = [poetry2nix.overlays.default];
        };
        poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
        };
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [poetryEnv poetry];
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
          dotnet = {
            path = ./dotnet;
            description = "Dotnet SWEng environment";
            welcomeText = ''
              # SilverRailTech Dotnet Software Engineering

              ## When the best is not enough, you call us

              - Pre-commit hooks
              - Nix flake development environment
              - Python + Poetry project
              - Git attributes
              - Git ignore
              - Direnv activation file

              Now give 'em hell marine

            '';
          };
        };
      }
    );
}
