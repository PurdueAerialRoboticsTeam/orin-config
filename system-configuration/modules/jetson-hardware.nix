{ config, pkgs, ... }:

{
  # Required NVIDIA components
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.nvidia-jetpack.enable = true;

  environment.systemPackages = with pkgs; [
    cudaPackages.cudnn
    cudaPackages.tensorrt
    cudaPackages.cutensor
    jetson-ffmpeg
    nvidia-jetpack
  ];

  # CUDA configuration
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L${pkgs.cudatoolkit}/lib";
    LD_LIBRARY_PATH = "${pkgs.cudatoolkit}/lib";
  };

  # Kernel modules
  boot.kernelModules = [ "nvgpu" "tegra" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
}
