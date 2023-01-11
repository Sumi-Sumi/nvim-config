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

  outputs = { self, nixpkgs, flake-utils, flakes }:
    let
      lib = nixpkgs.lib;

      isModules = file: with lib; if (hasSuffix ".nix" file) then strings.removeSuffix ".nix" file else false;
      modules = with builtins; lib.remove false (map isModules (attrNames (ls ./hm-module)));
      genModule = name: {
        inherit name;
        value = import ./modules/${name}.nix;
      };
      mkModules = with builtins; listToAttrs (map genModule modules);

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        let
          pkgs = import nixpkgs {
            system = "${system}";
            overlays = [ flakes.overlays.default ]; # nvfetcherもoverlayする
            config.allowUnfree = true;
          }; in
        with pkgs.legacyPackages.${system}; rec {
          nixosModules = mkModules;
        });
}
