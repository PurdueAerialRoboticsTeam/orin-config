{
  inputs,
  system,
  ...
}: {
  services.feonix.package = inputs.feonix.packages.${system}.feonix_fake_gnc;
}
