{ mode, config, pkgs, lib, soxin, ... }:

with lib;
let
  cfg = config.soxin.programs.termite;
in
{
  options = {
    soxin.programs.termite = soxin.lib.mkSoxinModule {
      inherit config;
      name = "termite";
      includeTheme = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (optionalAttrs (mode == "home-manager") {
      programs.termite = {
        enable = true;
      };
    })

    # add the theme configuration
    (optionalAttrs (mode == "home-manager") {
      programs.termite = cfg.theme.extraConfig;
    })
  ]);
}
