{
  description = "Orin System Manager";
  inputs = {
    feonix = {
      url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
      # ref = "master";
      # flake = true;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, flake-utils, nixpkgs, feonix, system-manager }: {
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        ./system-configuration/modules
        { services.feonix.enable = true; }
      ];
    };
  };
}
