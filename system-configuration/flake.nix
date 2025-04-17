{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    system-manager.url = "github:numtide/system-manager";
    feonix-flake.url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
  };

  outputs = { self, nixpkgs, system-manager, feonix-flake }:
    let
      mkSystemManager = {system ? "aarch64-linux", extraModules ? []}:
        system-manager.lib.makeSystemConfig {
          modules = [
            ./modules/feonix-base.nix
	    {
            config = {
              nixpkgs.hostPlatform = system;
              system-manager.allowAnyDistro = true;
              services.feonix.enable = true;
            };
          }
        ] ++ extraModules;
      }; 
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      systemConfigs = {
        default = mkSystemManager {
          extraModules = [
            ./modules/jetson-hardware.nix
          ];
        };
        dev = mkSystemManager {
          system = "x86_64-linux";
        };
      };
    };
}
