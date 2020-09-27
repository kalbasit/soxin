{
  description = "soxin: opiniated configs for everyone";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager } @ inputs:
    let
      inherit (nixpkgs) lib;
    in
    {
      nixosModules = {
        soxinNixOS = import ./modules/nixos/list.nix;
        soxinHome = import ./modules/home/list.nix;
        soxinOptions = import ./modules/options/list.nix;
      };

      lib = lib.extend (final: prev: {
        nixosSystem = import ./lib/nixos-system.nix {
          lib = prev;
          inherit self home-manager;
        };
      });
    };
}
