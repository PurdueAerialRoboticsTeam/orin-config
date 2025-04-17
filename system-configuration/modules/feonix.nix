{ config, lib, pkgs, feonix, ... }:

{
  # Feonix package integration
  environment.systemPackages = with feonix.packages.${pkgs.system}; [
    feonix-gnc
    configuranator2000
    sauron
    gnc-with-sitl
  ];

  # Feonix services
  systemd.services = {
    feonix-core = {
      enable = true;
      description = "Feonix Autonomous Control System";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${feonix.packages.${pkgs.system}.default}/bin/dad";
        Restart = "always";
        EnvironmentFile = "/etc/feonix.conf";
      };
    };
  };

  # Feonix configuration file
  environment.etc."feonix.conf".text = ''
    sensor_update_interval = 100
    gnc_mode = advanced
  '';
}
