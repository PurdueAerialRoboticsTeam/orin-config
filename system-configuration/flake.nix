{
  description = "Orin System Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    feonix.url = "github:PurdueAerialRoboticsTeam/feonix";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, feonix, system-manager }: {
    systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        ./modules
        # Import the Feonix NixOS module provided by your Feonix flake.
        feonix.nixosModules.feonix
        { services.feonix.enable = true; }
      ];
    };
  };
}
