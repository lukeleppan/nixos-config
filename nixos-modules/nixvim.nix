{ ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    #    ref = "nixos-24.05";
  });

in {
  imports = [ nixvim.nixosModules.nixvim ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    opts = {
      number = true;
      relativenumber = true;

      mouse = "a";
      showmode = false;
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;

      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;

      splitright = true;
      splitbelow = true;

      inccommand = "split";

      scrolloff = 10;
    };

    autoCmd = [{
      desc = "Highlight when yanking text";
      event = [ "TextYankPost" ];
      command = "lua vim.highlight.on_yank()";
    }];

    clipboard.register = "unnamedplus";

    # Colorscheme
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparentBackground = true;
        integrations = {
          illuminate.enabled = true;
          illuminate.lsp = true;
          native_lsp.enabled = true;
          telescope.enabled = true;
        };
      };
    };

    # Keymaps
    keymaps = [
      {
        mode = "i";
        key = "jk";
        action = "<Esc>";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
      }
      {
        mode = "n";
        key = "H";
        action = "<cmd>bprev<CR>";
      }
      {
        mode = "n";
        key = "L";
        action = "<cmd>bnext<CR>";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bd<CR>";
      }
    ];

    plugins = {
      auto-session = {
        enable = true;
        autoSave.enabled = true;
        autoRestore.enabled = true;
        autoSession = {
          enabled = true;
          enableLastSession = true;
        };
      };
      bufferline = {
        enable = true;
        diagnostics = "nvim_lsp";
      };
      lualine = {
        enable = true;
        extensions = [ "fzf" "oil" "lazy" "mason" "nvim-dap-ui" "trouble" ];
      };

      # CMP
      cmp = {
        enable = true;
        autoEnableSources = true;

        settings = {
          completion.autocomplete =
            [ "require('cmp.types').cmp.TriggerEvent.TextChanged" ];
          completion.completeopt = "menu,menuone,noselect";
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_document_symbol"; }
            { name = "cmdline"; }
            { name = "cmdline_history"; }
            { name = "treesitter"; }
            { name = "git"; }
            { name = "fuzzy_path"; }
            { name = "fuzzy_buffer"; }
          ];
          mapping = {
            "<C-y>" = "cmp.mapping.confirm({ select = true })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
          };
        };
      };
      cmp-fuzzy-buffer.enable = true;
      cmp-fuzzy-path.enable = true;
      cmp-cmdline.enable = true;
      cmp-cmdline-history.enable = true;
      cmp-git.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-treesitter.enable = true;
      cmp-fish.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true; # bash
          clangd.enable = true; # c/c++
          cmake.enable = true; # cmake
          csharp-ls.enable = true; # c#
          cssls.enable = true; # css
          dartls.enable = true; # dart
          docker-compose-language-service.enable = true; # docker compose
          dockerls.enable = true; # docker
          elixirls.enable = true; # elixir
          emmet_ls.enable = true;
          eslint.enable = true;
          fortls.enable = true; # fortran
          gdscript.enable = true; # gdscript
          gleam.enable = true; # gleam
          gopls.enable = true; # go
          graphql.enable = true; # graphql
          html.enable = true; # html
          htmx.enable = true; # htmx
          intelephense.enable = true; # php
          java-language-server.enable = true; # java
          kotlin-language-server.enable = true; # kotlin
          lua-ls.enable = true; # lua
          marksman.enable = true; # markdown
          nginx-language-server.enable = true; # nginx conf
          nushell.enable = true; # nu
          ocamllsp.enable = true; # ocaml
          pyright.enable = true; # python
          sqls.enable = true;
          svelte.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
          vuels.enable = true;
          nixd.enable = true; # nix
          taplo.enable = true; # toml
          zls.enable = true;
        };
      };
      nix.enable = true;
      nix-develop.enable = true;
      rustaceanvim.enable = true;
      crates-nvim.enable = true;
      zig.enable = true;
      treesitter = {
        enable = true;
        indent = true;
        nixvimInjections = true;
      };
      trouble = { enable = true; };
      lsp-lines.enable = true;
      surround.enable = true;
      lsp-format = { enable = true; };

      # Formatting
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = { formatting = { nixfmt.enable = true; }; };
      };

      # Testing

      # Utils
      oil = {
        enable = true;
        settings = {
          defaultFileExplorer = true;
          promptSaveOnSelectNewEntry = true;
        };
      };
      comment.enable = true;

      # Look and Feel
      noice = {
        enable = true;
        cmdline.enabled = true;
        notify.enabled = true;
        messages.enabled = true;
      };
      notify.enable = true;
      dressing.enable = true;
    };

  };
}
