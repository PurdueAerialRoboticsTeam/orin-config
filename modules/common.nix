{
  inputs,
  system,
  system-manager,
  ...
}: {
  imports = [
    ./feonix-base.nix
  ];
  config = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform = system;

    environment.systemPackages = [
      inputs.system-manager.packages.${system}.default
    ];
    system-manager.allowAnyDistro = true;

    # Enable feonix
    services.feonix.enable = true;

    /**
      * Doesn't work

    # Add system-manger binaries to the trusted path
    environment.etc."sudoers.d/secure_path".text = ''
      Defaults secure_path += ":/run/system-manager/sw/bin/:/nix/var/nix/profiles/default/bin/nix"
    '';
    environment.etc."sudoers.d/secure_path".mode = "0440";
    */
  };
}
