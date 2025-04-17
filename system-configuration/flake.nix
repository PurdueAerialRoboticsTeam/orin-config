{
  description = "Orin System Manager";
  inputs = {
    feonix = {
      type = "git";
      url = "ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
      ref = "master";
      flake = true;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.url = "github:numtide/flake-utils"; 
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
