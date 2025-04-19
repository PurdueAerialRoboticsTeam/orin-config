{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    system-manager.url = "github:numtide/system-manager";
    feonix.url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
  };

  outputs = {
    self,
    nixpkgs,
    system-manager,
    feonix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    mkSystemManager = {
      system ? "aarch64-linux",
      extraModules ? [],
    }:
      system-manager.lib.makeSystemConfig {
        extraSpecialArgs = {inherit inputs outputs;};
        modules =
          [
            ./modules/feonix-base.nix
            {
              config = {
                nixpkgs.hostPlatform = system;
                system-manager.allowAnyDistro = true;
                # services.feonix.enable = true;
              };
            }
          ]
          ++ extraModules;
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    systemConfigs = {
      default = mkSystemManager {
        extraModules = [
          ./modules/jetson-hardware.nix
          {
            _module.args.feonix = feonix;
          }
        ];
      };
      dev = mkSystemManager {
        system = "x86_64-linux";
        extraModules = [
          { _module.args.feonix = feonix; }
          {
            config = { nixpkgs.config.allowUnfree = true; };
          }
        ];
      };
    };
  };
}
