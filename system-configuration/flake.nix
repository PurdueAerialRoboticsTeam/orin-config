{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    system-manager.url = "github:numtide/system-manager";
    feonix.url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
  };

  outputs = { self, nixpkgs, system-manager, feonix }:
    let
      system = "aarch64-linux";
    in {
      systemConfigs.jetson = system-manager.lib.makeSystemConfig {
        modules = [
          ./modules/jetson-hardware.nix
          ({ pkgs, ... }: {
            environment.systemPackages = with feonix.packages.${system}; [
              feonix-gnc
              configuranator2000
              sauron
            ];
          })
        ];
      };
    };
}
