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
      };
    };
  };
}