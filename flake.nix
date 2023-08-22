{
  description = "Templates for Nix environments";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, ... }:
  {
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
  };
}