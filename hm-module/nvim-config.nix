#  neovim conf
#  I use conf sourcing ./nvim but you can manager from home manager.
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.nvim-my-conf;
in
{
  options = {
    programs.nvim-my-conf = {
      enable = mkEnableOption ''
        My nvim config
      '';
    };
  };
  config = mkIf cfg.enable {
    xdg = {
      configFile = {
        "nvim/lua".source = ../lua; # windowsとconfigを共有するため.config/nvimで管理する
        "nvim/init.lua".source = ../init.lua;
        "latexmk".source = ../latexmk;
      };
    };
    home.sessionVariables = {
      SQLITE_CLIB_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    };

    programs.neovim = {
      enable = true; # Replace from vi&vim to neovim
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      extraPackages = with pkgs; [
        cargo
        deno
        gcc
        gnumake
        go
        ninja
        patchelf
        sqlite
        yarn

        ripgrep

        # LSP
        clang-tools # Not run binary pkg installed by mason
        neovim-remote
      ];

      extraPython3Packages = ps: with ps; [
        isort
        docformatter
        doq
      ];
    };
  };
}
