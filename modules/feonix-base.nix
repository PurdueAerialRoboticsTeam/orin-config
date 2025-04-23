{
  config,
  pkgs,
  inputs,
  lib,
  feonix,
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
  /*
  environment.systemPackages = with inputs.feonix.packages.${pkgs.system}; [
    feonix
    configuranator2000
    sauron
    sitl
    gnc-with-sitl
  ];
  */
  config = {
      environment.systemPackages = with feonix.packages.${pkgs.system}; [
        feonix
        configuranator2000
        sauron
        sitl
        gnc-with-sitl
      ];

      environment.etc."feonix-config.toml".source = pkgs.lib.cleanSource ./feonix-config.toml;
      environment.etc."feonix-models/yolov8n.onnx".source = pkgs.lib.cleanSource ./models/yolov8n.onnx;

      systemd.services.feonix-core = {
        description = "Feonix Core Service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe feonix.packages.${pkgs.system}.jetson}";
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
