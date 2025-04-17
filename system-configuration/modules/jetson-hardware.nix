{ config, lib, pkgs, ... }:

{
  # NVIDIA Jetson specific configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.nvidia-jetpack.enable = true;

  # CUDA configuration
  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.cudaPackages.cudnn
      pkgs.cudaPackages.tensorrt
    ];
  };

  # Required kernel modules
  boot.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModprobeConfig = ''
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
  '';
}
