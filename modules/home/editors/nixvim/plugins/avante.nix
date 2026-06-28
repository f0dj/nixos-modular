/**
 * @file: modules/home/editors/nixvim/plugins/avante.nix
 * @purpose: Avante AI plugin configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.avante;
in
{
  options.my.editors.nixvim.plugins.avante = {
    enable = lib.mkEnableOption "Avante AI plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.avante = {
        enable = true;
        settings = {
          provider = "deepseek";
          providers = {
            gemini = {
              endpoint = "https://generativelanguage.googleapis.com/v1beta";
              model = "gemini-2.0-flash";
              api_key_name = "cmd:cat /run/secrets/google_api_key";
              use_ReAct_prompt = true;
              extra_request_body = {
                temperature = 0;
                max_output_tokens = 4096;
              };
            };
            deepseek = {
              endpoint = "https://api.deepseek.com/v1";
              model = "deepseek-coder";
              api_key_name = "cmd:cat /run/secrets/deepseek_api_key";
              use_ReAct_prompt = true;
              extra_request_body = {
                temperature = 0;
                max_output_tokens = 4096;
              };
            };
          };
          mappings = {
            diff = {
              ours = "co";
              theirs = "ct";
              none = "c0";
              both = "cb";
              next = "]x";
              prev = "[x";
            };
          };
          hints.enabled = true;
          windows = {
            wrap = true;
            width = 30;
            sidebar_header = {
              align = "center";
              rounded = true;
            };
          };
          highlights.diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
          diff = {
            debug = false;
            autojump = true;
            list_opener = "copen";
          };
        };
      };
    };
  };
}
