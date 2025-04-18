{
  system-manager,
  feonix,
  nixpkgs,
}: {
  system,
  hardwareModule,
  extraModules ? [],
}:
system-manager.lib.makeSystemConfig {
  inherit system;

  modules =
    [
      hardwareModule
      ({
        config,
        pkgs,
        ...
      }: {
        environment.systemPackages = with feonix.packages.${system}; [
          feonix-gnc
          configuranator2000
          sauron
        ];
      })
    ]
    ++ extraModules;

  # Optionally add specialArgs or other system-manager-specific features here
}
