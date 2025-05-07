{
  lib,
  dir,
}: let
  moduleFiles = builtins.readDir dir;

  # Filter to only .nix files
  nixModules =
    lib.filterAttrs (
      name: type:
        type == "regular" && builtins.match ".*\\.nix" name != null
    )
    moduleFiles;

  # Build map: filename without ".nix" → import path
  moduleMap =
    builtins.mapAttrs (
      filename: _:
        import (./systems + "/${filename}")
    )
    nixModules;

  # Now moduleMap is:
  # { "laptop.nix" = <import>; "server.nix" = <import>; ... }

  # If you want key without .nix extension:
  cleanModuleMap =
    builtins.mapAttrs (
      filename: value:
        value
    ) (builtins.listToAttrs (builtins.map (
      filename: {
        name = builtins.replaceStrings [".nix"] [""] filename;
        value = import (dir + "/${filename}");
      }
    ) (builtins.attrNames nixModules)));
in
  cleanModuleMap
