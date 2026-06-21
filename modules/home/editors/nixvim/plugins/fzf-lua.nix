/**
 * @file: modules/home/editors/nixvim/plugins/fzf-lua.nix
 * @purpose: fzf-lua configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.fzf-lua;
in
{
  options.my.editors.nixvim.plugins.fzf-lua = {
    enable = lib.mkEnableOption "fzf-lua plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.fzf-lua = {
      enable = true;

      profile = "default";

      settings = {
        winopts = {
          height = 0.9;
          width = 0.8;
          row = 0.5;
          col = 0.5;
          border = "rounded";
          preview = {
            default = "bat";
            border = "rounded";
            wrap = "nowrap";
            hidden = "nohidden";
            vertical = "down:50%";
            horizontal = "right:50%";
            layout = "horizontal";
            flip_columns = 120;
            title = true;
            title_pos = "center";
            scrollbar = "float";
            scrolloff = -2;
            delay = 100;
          };
        };
        previewers = {
          bat = {
            cmd = "bat";
            args = "--style=numbers,changes --color=always --theme=Nord";
          };
        };
        keymap = {
          fzf = {
            "ctrl-t" = "toggle-preview";
            "ctrl-q" = "select-all+accept";
            "ctrl-/" = "toggle-preview-wrap";
            "ctrl-p" = "toggle-preview";
            "alt-j" = "preview-page-down";
            "alt-k" = "preview-page-up";
            "ctrl-f" = "preview-page-down";
            "ctrl-b" = "preview-page-up";
          };
          builtin = {
            "ctrl-/" = "toggle-preview-wrap";
            "ctrl-f" = "preview-page-down";
            "ctrl-b" = "preview-page-up";
            "shift-down" = "preview-down";
            "shift-up" = "preview-up";
          };
        };
        oldfiles = {
          cwd_only = false;
          stat_file = true;
          include_current_session = true;
        };
        files = {
          prompt = "Files❯ ";
          multiprocess = true;
          git_icons = true;
          file_icons = true;
          color_icons = true;
        };
        grep = {
          prompt = "Rg❯ ";
          input_prompt = "Grep For❯ ";
          multiprocess = true;
          git_icons = true;
          file_icons = true;
          color_icons = true;
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e";
        };
        buffers = {
          prompt = "Buffers❯ ";
          file_icons = true;
          color_icons = true;
        };
      };

      keymaps = {
        "<leader>fa" = {
          action = "autocmds";
          options = {
            desc = "Find autocmds";
          };
        };
        "<leader>fe" = {
          action = "diagnostics_document";
          settings = {
            severity_only = "error";
          };
          options = {
            desc = "Find buffer error diagnostics";
          };
        };
        "<leader>fE" = {
          action = "diagnostics_workspace";
          settings = {
            severity_only = "error";
          };
          options = {
            desc = "Find workspace error diagnostics";
          };
        };
        "<leader>fd" = {
          action = "diagnostics_document";
          options = {
            desc = "Find buffer diagnostics";
          };
        };
        "<leader>fD" = {
          action = "diagnostics_workspace";
          options = {
            desc = "Find workspace diagnostics";
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "Find help tags";
          };
        };
        "<leader>fk" = {
          action = "keymaps";
          options = {
            desc = "Find keymaps";
          };
        };
        "<leader>fp" = {
          action = "files";
          settings = {
            cwd = "~/projects";
          };
          options = {
            desc = "Find project files";
          };
        };
        "<leader>fs" = {
          action = "lsp_document_symbols";
          options = {
            desc = "Find LSP document symbols";
          };
        };
        "<leader>fT" = {
          action = "colorschemes";
          options = {
            desc = "Find themes/colorschemes";
          };
        };
        "<leader>/" = {
          action = "live_grep";
          options = {
            desc = "Live grep in workspace";
          };
        };
        "<leader>fO" = {
          action = "oldfiles";
          options = {
            desc = "Find recent files (smart/frecency)";
          };
        };
        "<leader>f?" = {
          action = "grep_curbuf";
          options = {
            desc = "Fuzzy find in current buffer";
          };
        };
        "<leader>f'" = {
          action = "marks";
          options = {
            desc = "Find marks";
          };
        };
        "<leader>f/" = {
          action = "blines";
          options = {
            desc = "Find lines in current buffer";
          };
        };
        "<leader>fr" = {
          action = "resume";
          options = {
            desc = "Resume last search";
          };
        };
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Find open buffers";
          };
        };
        "<leader><space>" = {
          action = "files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>fm" = {
          action = "manpages";
          options = {
            desc = "Find man pages";
          };
        };
        "<leader>fo" = {
          action = "oldfiles";
          options = {
            desc = "Find old/recent files";
          };
        };
        "<leader>fq" = {
          action = "quickfix";
          options = {
            desc = "Find quickfix entries";
          };
        };
        "<leader>ld" = {
          action = "lsp_definitions";
          options = {
            desc = "Go to LSP definitions";
          };
        };
        "<leader>li" = {
          action = "lsp_implementations";
          options = {
            desc = "Go to LSP implementations";
          };
        };
        "<leader>lD" = {
          action = "lsp_references";
          options = {
            desc = "Find LSP references";
          };
        };
        "<leader>lt" = {
          action = "lsp_typedefs";
          options = {
            desc = "Go to LSP type definitions";
          };
        };
        "<leader>fS" = {
          action = "spell_suggest";
          options = {
            desc = "Find spelling suggestions";
          };
        };
        "<leader>fH" = {
          action = "highlights";
          options = {
            desc = "Find highlight groups";
          };
        };
        "<leader>gB" = {
          action = "git_branches";
          options = {
            desc = "Find git branches";
          };
        };
        "<leader>gl" = {
          action = "git_commits";
          options = {
            desc = "Find git commits (log)";
          };
        };
        "<leader>gf" = {
          action = "git_bcommits";
          options = {
            desc = "Find git commits for current file";
          };
        };
        "<leader>gL" = {
          action = "git_bcommits";
          options = {
            desc = "Find git commits for current line";
          };
        };
        "<leader>gs" = {
          action = "git_status";
          options = {
            desc = "Find git status files";
          };
        };
        "<leader>gS" = {
          action = "git_stash";
          options = {
            desc = "Find git stashes";
          };
        };
      };
    };
  };
}
