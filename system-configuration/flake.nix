{
  description = "The Feonix Project Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    fenix = {
      url = "github:/nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    gnc-flake.url = "git+ssh://git@github.com/PurdueAerialRoboticsTeam/GNC-2024-2025.git";
    gnc-flake.inputs.nixpkgs.follows = "nixpkgs";

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, crane, pre-commit-hooks, fenix, gnc-flake }:
    systemConfigurations = {
    default = system-manager.lib.makeSystemConfig {
        modules = [
        ./modules/default.nix
        # Add other module files as needed
        ];
    };
    # Define additional configurations as needed
    };
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inherit (pkgs) lib;

        toolchain = fenix.packages.${system}.stable.toolchain;
        craneLib = (crane.mkLib pkgs).overrideToolchain toolchain;
        # src = craneLib.cleanCargoSource ./.;
        src = lib.fileset.toSource {
          # Temporary solution until nextests works
          root = ./.;
          fileset = lib.fileset.unions [
            (craneLib.fileset.commonCargoSources ./.)
            ./dad/data/test.csv
            ./dad/data/0007flight.csv
          ];
        };

        # Common arguments can be set here to avoid repeating them later
        # Note: changes here will rebuild all dependency crates
        commonArgs = rec {
          inherit src;
          strictDeps = true;

          nativeBuildInputs = with pkgs; [ pkg-config ];

          buildInputs = with pkgs; [
            # Add additional build inputs here
            onnxruntime
            openssl
            makeWrapper
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # Additional darwin specific inputs can be set here
            # pkgs.libiconv
          ];

          ORT_STRATEGY = "system";
          ORT_LIB_LOCATION = "${pkgs.onnxruntime}";
        };

        cargoArtifacts = craneLib.buildDepsOnly commonArgs;

        individualCrateArgs = commonArgs // {
          inherit cargoArtifacts;
          inherit (craneLib.crateNameFromCargoToml { inherit src; }) version;
          # NB: we disable tests since we'll run them all via cargo-nextest
          doCheck = true; # TODO: disable when nextests is fixed
        };

        makeCrate = crateName: craneLib.buildPackage (individualCrateArgs // {
          inherit src;
          pname = crateName;
          cargoExtraArgs = "-p " + crateName;
        });


        gnc = gnc-flake.outputs.packages.${system}.default;

        glue = makeCrate "glue";
        glue_derive = makeCrate "glue_derive";
        configuranator2000 = makeCrate "configuranator2000";
        sauron = makeCrate "sauron";

        feonix = craneLib.buildPackage (individualCrateArgs // {
          inherit src;
          pname = "dad";
          cargoExtraArgs = "-p dad";
          buildInputs = [ sauron ] ++ individualCrateArgs.buildInputs;
          postInstall = ''
            wrapProgram $out/bin/dad \
              --set PATH "${lib.makeBinPath [ sauron ]}"
          '';
        });
        feonix-gnc = craneLib.buildPackage (individualCrateArgs // {
          inherit src;
          pname = "dad";
          cargoExtraArgs = "-p dad --features gnc";
          buildInputs = [ sauron gnc ] ++ individualCrateArgs.buildInputs;
          postInstall = ''
            wrapProgram $out/bin/dad \
              --set PATH "${lib.makeBinPath [
                sauron
                gnc
              ]}"
          '';
        });

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = pkgs.lib.cleanSource ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            clippy.enable = true;
            clippy.packageOverrides.cargo = toolchain;
            clippy.packageOverrides.clippy = toolchain;
            rustfmt.enable = true;
            rustfmt.packageOverrides.cargo = toolchain;
          };
        };

      in
      {
        checks = {
          # inherit pre-commit-check;
          inherit glue glue_derive feonix configuranator2000 sauron;

          # Run clippy (and deny all warnings) on the workspace source,
          # again, reusing the dependency artifacts from above.
          #
          # Note that this is done as a separate derivation so that
          # we can block the CI if there are issues here, but not
          # prevent downstream consumers from building our crate by itself.
          my-workspace-clippy = craneLib.cargoClippy (commonArgs // {
            inherit cargoArtifacts;
            # cargoClippyExtraArgs = "--all-targets -- --deny warnings";
            cargoClippyExtraArgs = "--all-targets";
          });

          my-workspace-doc = craneLib.cargoDoc (commonArgs // {
            inherit cargoArtifacts;
          });

          # Check formatting
          my-workspace-fmt = craneLib.cargoFmt {
            inherit src;
          };

          my-workspace-toml-fmt = craneLib.taploFmt {
            src = pkgs.lib.sources.sourceFilesBySuffices src [ ".toml" ];
            # taplo arguments can be further customized below as needed
            taploExtraArgs = "--config ./taplo.toml --verbose";
          };

          /*
          # Run tests with cargo-nextest
          # Consider setting `doCheck = false` on other crate derivations
          # if you do not want the tests to run twice
          my-workspace-nextest = craneLib.cargoNextest (commonArgs // {
            inherit cargoArtifacts;
            partitions = 1;
            partitionType = "count";
            cargoNextestPartitionsExtraArgs = "--no-tests=pass";
          });
          */

          # Ensure that cargo-hakari is up to date
          my-workspace-hakari = craneLib.mkCargoDerivation {
            inherit src;
            pname = "my-workspace-hakari";
            cargoArtifacts = null;
            doInstallCargoArtifacts = false;

            buildPhaseCargoCommand = ''
              cargo hakari generate --diff  # workspace-hack Cargo.toml is up-to-date
              cargo hakari manage-deps --dry-run  # all workspace crates depend on workspace-hack
              cargo hakari verify
            '';

            nativeBuildInputs = [
              pkgs.cargo-hakari
            ];
          };
        };

        packages = {
          inherit configuranator2000 sauron feonix feonix-gnc;
          default = feonix-gnc;
        };

        devShells.default = craneLib.devShell {
          inherit (pre-commit-check) shellHook;

          checks = self.checks.${system};

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            onnxruntime
          ] ++ pre-commit-check.enabledPackages;

          packages = with pkgs; [
            git
            curl
            pre-commit
            cargo-hakari
          ];

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
          ];
        };
      }
    );
}

