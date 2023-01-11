#  neovim conf
#  I use conf sourcing ./nvim but you can manager from home manager.
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.nvim_my_conf;
in

{
  options =
    {
      programs.nvim_my_conf = {
        enable = mkEnableOption ''
          neovim with my setting
        '';
      };
    };
  config = mkIf cfg.enable {
    xdg = {
      configFile = {
        "nvim/lua".source = ./lua; # windowsとconfigを共有するため.config/nvimで管理する
        "nvim/init.lua".source = ./init.lua;
        "latexmk".source = ./latexmk;
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
        go
        cargo
        ninja
        gnumake
        gcc # For nvim-treesitter
        # zlib
        patchelf
        sqlite
        yarn

        ripgrep
        silver-searcher # ToDO どっちか消す
      ];

      extraPython3Packages = ps: with ps; [
        isort
        docformatter
        doq
      ];
    };
  };
}
