{ nixpkgs, self, ... }:

let
  inherit (self.lib.modules) keyboard themes;

  inherit (nixpkgs) lib;
  inherit (lib)
    optionalAttrs
    mkEnableOption
    mkOption
    recursiveUpdate
    types
    ;
in
{ config
, name
, includeKeyboardLayout ? false
, includeTheme ? false
, includeTool ? false
, includeProgrammingLanguage ? false
, extraOptions ? { }
}:

recursiveUpdate
{
  enable = mkEnableOption name;

  keyboardLayout = optionalAttrs includeKeyboardLayout (mkOption {
    type = keyboard.layoutModule;
    default = config.soxin.settings.keyboard.defaultLayout;
    description = "Keyboard layout to use for ${name}.";
  });

  theme = optionalAttrs includeTheme (mkOption {
    type = with types; oneOf [ str themes.themeModule ];
    default = config.soxin.settings.theme;
    description = "Theme to use for ${name}.";
    apply = value:
      if builtins.isString value then config.soxin.themes.${value}.${name}
      else value.${name};
  });

  tool = optionalAttrs includeTool (mkOption {
    type = with types; listOf [ str modules.tools.toolsModule ];
    default = config.soxin.settings.tools;
    description = "Tool to use for ${name}.";
    apply = value:
      if builtins.isString value then config.soxin.tools.${value}.${name}
      else value.${name};
  });

  programmingLanguage = optionalAttrs includeProgrammingLanguage (mkOption {
    type = with types; listOf [ str modules.programmingLanguages.programmingLanguagesModule ];
    default = config.soxin.settings.programmingLanguages;
    description = "Programming language to use for ${name}.";
    apply = value:
      if builtins.isString value then config.soxin.programmingLanguages.${value}.${name}
      else value.${name};
  });
}
  extraOptions
