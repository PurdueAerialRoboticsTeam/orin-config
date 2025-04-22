{
  config,
  pkgs,
  ...
}: {
/*
  config = {
    # CUDA configuration (CORRECTED)
    environment.variables = {
      CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.cudaPackages.cudnn}/lib";
    };
  };

  # NVIDIA Jetson hardware configuration
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.nvidia-jetpack.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    cudaPackages.cudnn
    cudaPackages.tensorrt
    nvidia-jetpack
  ];
*/
}
