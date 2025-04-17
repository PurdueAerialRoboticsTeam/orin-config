{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    feonix.url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/feonix.git";
  };
  outputs = { self, nixpkgs, system-manager, feonix }:
    let
      # Supported systems and base configuration
      systems = [ "aarch64-linux" "x86_64-linux" ];
      mkConfig = system: {
        nixpkgs.hostPlatform = system;
        environment.systemPackages = with feonix.packages.${system}; [
          feonix-gnc
          configuranator2000
          sauron
        ];
      };
      
      # Jetson-specific additions
      jetsonModules = [
        {
          boot.kernelPackages = nixpkgs.legacyPackages.aarch64-linux.linuxPackages_latest;
          environment.variables = {
            CUDA_PATH = "${nixpkgs.legacyPackages.aarch64-linux.cudatoolkit}";
            LD_LIBRARY_PATH = "${nixpkgs.legacyPackages.aarch64-linux.stdenv.cc.cc.lib}/lib";
          };
        }
      ];
    in {
      systemConfigs = nixpkgs.lib.genAttrs systems (system:
        system-manager.lib.makeSystemConfig {
          modules = [ (mkConfig system) ] ++ (
            if system == "aarch64-linux" then jetsonModules else []
          );
        }
      );

      packages = nixpkgs.lib.genAttrs systems (system: {
        default = self.systemConfigs.${system}.config.system.build.toplevel;
      });
    };
}
