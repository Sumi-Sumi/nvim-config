{
  description = "Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flakes = {
      url = "github:Sumi-Sumi/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-utils, flakes }:
    let
      lib = nixpkgs.lib;

      ls = path: builtins.readDir path;
      isModules = file: with lib; if (hasSuffix ".nix" file) then strings.removeSuffix ".nix" file else null;
      modules = with builtins; lib.remove null (map isModules (attrNames (ls ./hm-modules)));
      genModule = name: {
        inherit name;
        value = import ./hm-modules/${name}.nix;
      };
      mkModules = with builtins; listToAttrs (map genModule modules);
    in
    {
      nixosModules = mkModules;
    };
}
