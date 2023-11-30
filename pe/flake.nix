{
  description = "Platform Engineering environment";
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
          # Required for Terraform's BSL
          config.allowUnfree = true;
          overlays = [poetry2nix.overlays.default];
        };
        poetryEnv = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
        };
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [poetryEnv terraform terragrunt terraform-docs awscli2 poetry];
            shellHook = ''
              export SKIP=check-renovate,check-github-actions,hadolint,copy-repeated-files
              pre-commit install --install-hooks
            '';
          };
      }
    );
}
