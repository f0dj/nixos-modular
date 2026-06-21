/**
 * @file: packages/snacks-nvim/default.nix
 * @purpose: Package definition for snacks-nvim Neovim plugin.
 * @type: Package
 * @namespace: my
 */
{ inputs
, pkgs
, vimUtils
,
}:
vimUtils.buildVimPlugin {
  pname = "snacks-nvim";
  src = inputs.snacks-nvim;
  version = inputs.snacks-nvim.shortRev;

  dependencies = [ pkgs.vimPlugins.trouble-nvim ];

  nvimSkipModule = [
    "snacks.dashboard"
    "snacks.indent"
    "snacks.input"
    "snacks.notifier"
    "snacks.picker.actions"
    "snacks.picker.config.highlights"
    "snacks.picker.core.list"
    "snacks.picker.util.db"
    "snacks.terminal"
    "snacks.win"
    "snacks.zen"
    "snacks.dim"
    "snacks.git"
    "snacks.lazygit"
    "snacks.scratch"
    "snacks.scroll"
    "snacks.words"
    "snacks.image.init"
    "snacks.image.placement"
    "snacks.image.image"
    "snacks.image.convert"
    # Add the failing modules from the error:
    "snacks.picker.util.diff"
    "snacks.picker.source.gh"
    "snacks.gh.render.init"
    "snacks.gh.actions"
    "snacks.gh.init"
    "snacks.gh.buf"
    "snacks.explorer.init"
  ];
}
