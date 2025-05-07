{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  feonixPackageSet = {
    inherit (inputs.feonix.packages.${pkgs.system}) feonix feonix_fake_gnc jetson;
  };
in {
  options.services.feonix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Feonix daemon service";
    };

    package = lib.options.mkPackageOption feonixPackageSet "jetson" {
      extraDescription = "The package to use to run feonix";
    };
  };
  config = lib.mkIf config.services.feonix.enable {
    environment.systemPackages = with inputs.feonix.packages.${pkgs.system}; [
      config.services.feonix.package
      configuranator2000
    ];

    environment.etc."feonix-config.toml".source = pkgs.lib.cleanSource ./feonix-config.toml;
    environment.etc."feonix-models/yolov8n.onnx".source = pkgs.lib.cleanSource ./models/yolov8n.onnx;

    /*
    systemd.tmpfiles.rules = [
      "L+ /feonix-images - - - - ${./images}"
    ];
    */

    systemd.services.feonix-core = {
      description = "Feonix Core Service";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${lib.getExe config.services.feonix.package}";
        Restart = "always";
        Environment = [
          "PC_DISABLE_TUI=1" # Disable process compose terminal ui
          "FEONIX_CONFIG_PATH=/etc/feonix-config.toml"
          "ORT_LIB_LOCATION=${pkgs.onnxruntime}/lib"
          "LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudatoolkit}/lib"
        ];
      };
    };
  };
}
