{
  description = "Platform Engineering environment";
  inputs = {
    # https://github.com/nix-community/poetry2nix/issues/1291
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
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
          # Required for Terraform's BSL
          config.allowUnfree = true;
        };
        poetryEnv = mkPoetryEnv {
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
