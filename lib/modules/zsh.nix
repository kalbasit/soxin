# vim:ft=nix:

{ lib }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;

in
{
  pluginModule = with types; submodule {
    options = {
      src = mkOption {
        type = path;
        description = ''
          Path to the plugin folder.
          Will be added to <envar>fpath</envar> and <envar>PATH</envar>.
        '';
      };

      name = mkOption {
        type = str;
        description = ''
          The name of the plugin.
          Don't forget to add <option>file</option>
          if the script name does not follow convention.
        '';
      };

      file = mkOption {
        type = str;
        description = "The plugin script to source.";
      };
    };
  };
}
