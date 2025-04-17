# ./modules/default.nix

{ config, pkgs, lib, inputs, ... }:

let
  feonixPkg = inputs.feonix.packages.${config.system}.feonix;
in {
  # 1) option definition (already there)
  options.services.feonix = {
    enable = lib.mkOption {
      type    = lib.types.bool;
      default = false;
      description = "Enable the Feonix daemon service";
    };
  };

  # 2) set it to true here:
  config = {
    # Enable the service:
    services.feonix.enable = true;

    # When enabled, the rest of your module will install & start it:
    environment.systemPackages = [ feonixPkg ];

    systemd.services.feonix = {
      description = "Feonix Daemon";
      after       = [ "network.target" ];
      wantedBy    = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${feonixPkg}/bin/dad";
      serviceConfig.Restart = "always";
    };
  };
}

