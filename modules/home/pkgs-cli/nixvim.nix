{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.custom-home-modules.nixvim;
in {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  options.custom-home-modules.nixvim = {
    enable = lib.mkEnableOption "nixvim setup";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      globals.netrw_banner = 0;
      opts = {
        number = true;
        relativenumber = true;
        colorcolumn = "80";
        termguicolors = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        smartindent = true;
        spell = true;
        spelllang = "nl,en";
      };
      plugins = {
        fugitive.enable = true;
        nvim-colorizer.enable = true;
        lsp = {
          enable = true;
          keymaps.lspBuf = {
            df = "format";
          };
          servers = {
            nixd = {
              enable = true;
              settings = {
                nixpkgs.expr = "import <nixpkgs> { }";
                formatting.command = ["alejandra"];
                options.nixos.expr = "(builtins.getFlake \"/home/bas/git/nix-conf\").nixosConfigurations.lightbox.options";
                options.home_manager.expr = "(import <home-manager/modules> { configuration = /home/bas/git/nix-conf/hosts/lightbox/home.nix; pkgs = import <nixpkgs> {}; }).options";
              };
            };
          };
        };
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
            ];
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };
        fzf-lua = {
          enable = true;
          keymaps = {
            "<C-p>" = "oldfiles";
          };
        };
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            bash
            python
            nix
            markdown
            json
            lua
            regex
            toml
            yaml
          ];
        };
      };
    };
  };
}
