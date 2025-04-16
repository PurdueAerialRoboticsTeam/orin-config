{
  description = "Feonix Jetson System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    feonix.url = "github:PurdueAerialRoboticsTeam/feonix";
  };

  outputs = { self, nixpkgs, system-manager, feonix }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in {
      systemConfigs = {
        jetson = system-manager.lib.makeSystemConfig {
          inherit system pkgs;
          modules = [
            ./modules/feonix-base.nix
            ./modules/jetson-hardware.nix
            feonix.nixosModules.default
          ];
        };
      };
    };
}
