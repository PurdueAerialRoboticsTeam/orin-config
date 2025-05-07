{
  inputs,
  system,
  ...
}: {
  services.feonix.package = inputs.feonix.packages.${system}.jetson;
}
