{ config, lib, pkgs, ... }:

{
  # Base system configuration
  environment.systemPackages = with pkgs; [
    vim htop tmux git
  ];

  # Standard environment variables
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # System-wide settings
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
