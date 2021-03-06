{ nixpkgs, ... }:

let
  inherit (nixpkgs) lib;
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

in
{
  # TODO: Bring this from home-manager!
  pluginWithConfigModule = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
}
