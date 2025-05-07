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
    lib = nixpkgs.lib;

    systemDefs = import ./lib/readModuleMap.nix {
      inherit lib;
      dir = ./systems;
    };
    configurations = import ./lib/readModuleMap.nix {
      inherit lib;
      dir = ./configurations;
    };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.alejandra;
    systemConfigs = builtins.listToAttrs (
      builtins.concatMap (
        systemName: let
          systemDef = systemDefs.${systemName};
        in
          builtins.map (configurationName: {
            name = "${systemName}-${configurationName}";
            value = system-manager.lib.makeSystemConfig {
              extraSpecialArgs = {
                inherit inputs outputs;
                inherit (systemDef) system;
              };
              modules = [
                ./modules/common.nix
                systemDef.module
                configurations.${configurationName}
              ];
            };
          }) (builtins.attrNames configurations)
      ) (builtins.attrNames systemDefs)
    );
  };
}
