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
                environment.systemPackages = [
                  system-manager.packages.${system}.default
                ];
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
        ];
      };
      dev = mkSystemManager {
        system = "x86_64-linux";
      };
    };
  };
}
