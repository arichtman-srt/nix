{
  description = "Platform Engineering environment";
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
  outputs = { nixpkgs, utils, self, poetry2nix, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        pkgs = import nixpkgs {
            inherit system;
          };
          poetryEnv = mkPoetryEnv {
            projectDir = ./.;
          };
      in {
        devShell = with pkgs; mkShell {
          buildInputs = [ poetryEnv terraform terragrunt awscli2 poetry graphviz ];
            shellHook = ''
            pre-commit install --install-hooks
            echo "Entered THE AWS ZONE"
          '';
      };
    }
  );
}
