{ self, lib, home-manager, nix-darwin }:

with lib;

{
  # The global modules are included in both nix-darwin and home-manager.
  globalModules ? [ ]

  # Home-manager specific modules.
, hmModules ? [ ]

  # Nix darwin specific modules.
, darwinModules ? [ ]

  # The global extra arguments are included in both nix-darwin and home-manager.
, globalSpecialArgs ? { }

  # Home-manager specific extra arguments.
, hmSpecialArgs ? { }

  # Nix darwin specific extra arguments.
, darwinSpecialArgs ? { }

, ...
} @ args:
let
  args' = removeAttrs args [
    "globalModules"
    "hmModules"
    "darwinModules"

    "globalSpecialArgs"
    "hmSpecialArgs"
    "darwinSpecialArgs"
  ];
in
nix-darwin.darwinSystem (recursiveUpdate args' {
  specialArgs = {
    # send home-manager down to the nix-darwin modules
    inherit home-manager;

    # the mode allows us to tell at what level we are within the modules.
    mode = "nix-darwin";

    # send soxin down to nix-darwin.
    soxin = self;
  }
  # include the global special arguments.
  // globalSpecialArgs
  # include the nix-darwin special arguments.
  // nixosSpecialArgs;


  modules =
    # include the global modules
    globalModules
    # include the nix-darwin modules
    ++ nixosModules
    # include Soxin modules
    ++ (singleton self.nixosModule)
    # include home-manager modules
    ++ (singleton home-manager.nixosModules.home-manager)
    # configure Nix registry so users can find soxin
    ++ singleton { nix.registry.soxin.flake = self; }
    # configure home-manager
    ++ (singleton {
      # tell home-manager to use the global (as in nix-darwin system-level) pkgs and
      # install all  user packages through the users.users.<name>.packages.
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.extraSpecialArgs = {
        # send home-manager down to the home-manager modules
        inherit home-manager;

        # the mode allows us to tell at what level we are within the modules.
        mode = "home-manager";
        # send soxin down to home-manager.
        soxin = self;
      }
      # include the global special arguments.
      // globalSpecialArgs
      # include the home-manager special arguments.
      // hmSpecialArgs;

      home-manager.sharedModules =
        # include the global modules
        globalModules
        # include the home-manager modules
        ++ hmModules
        # include Soxin module
        ++ (singleton self.nixosModule);
    });
})
