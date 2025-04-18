{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  /*
  options.services.feonix = {
    enable = lib.mkOption {
      type    = lib.types.bool;
      default = false;
      description = "Enable the Feonix daemon service";
    };
  };
  */
  environment.systemPackages = with inputs.feonix.packages.${pkgs.system}; [
    feonix
    configuranator2000
    sauron
    sitl
    gnc-with-sitl
  ];
  /*
  config = {
      environment.systemPackages = with feonix.packages.${pkgs.system}; [
        feonix
        configuranator2000
        sauron
        sitl
        gnc-with-sitl
      ];
  */
  /*
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
  };
  */
}
