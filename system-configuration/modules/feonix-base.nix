{ config, pkgs, feonix, ... }:

{
  environment.systemPackages = with feonix.packages.${pkgs.system}; [
    feonix-gnc
    configuranator2000
    sauron
    sitl
    gnc-with-sitl
  ];

  systemd.services.feonix-core = {
    description = "Feonix Core Service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${feonix.packages.${pkgs.system}.default}/bin/dad";
      Restart = "always";
      Environment = [
        "ORT_LIB_LOCATION=${pkgs.onnxruntime}/lib"
        "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit}/lib"
      ];
    };
  };
}
