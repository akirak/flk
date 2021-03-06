{
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      latest.url = "nixpkgs";
      digga.url = "github:divnix/digga/master";

      ci-agent = {
        url = "github:hercules-ci/hercules-ci-agent";
        inputs = { nix-darwin.follows = "darwin"; nixos-20_09.follows = "nixos"; nixos-unstable.follows = "latest"; };
      };
      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";
      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";
      naersk.url = "github:nix-community/naersk";
      naersk.inputs.nixpkgs.follows = "latest";
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "latest";
      nixos-hardware.url = "github:nixos/nixos-hardware";
      impermanence.url = "github:nix-community/impermanence";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";

      nyxt = {
        url = "github:ngi-nix/nyxt";
        inputs.nixpkgs.follows = "latest";
      };
    };

  outputs =
    { self
    , pkgs
    , digga
    , nixos
    , ci-agent
    , home
    , nixos-hardware
    , nur
    , agenix
    , nyxt
    , ...
    } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [
        "x86_64-linux"
      ];

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importers.overlays ./overlays) ];
          overlays = [
            ./pkgs/default.nix
            pkgs.overlay # for `srcs`
            nur.overlay
            agenix.overlay
          ];
        };
        latest = {
          overlays = [
            nyxt.overlay
          ];
        };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          modules = ./modules/module-list.nix;
          externalModules = [
            { _module.args.ourLib = self.lib; }
            ci-agent.nixosModules.agent-profile
            home.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            agenix.nixosModules.age
            ./modules/customBuilds.nix
          ];
        };

        imports = [ (digga.lib.importers.hosts ./hosts) ];
        hosts = {
          chen = {
            channelName = "latest";
          };
        };
        importables = rec {
          profiles = digga.lib.importers.rakeLeaves ./profiles // {
            users = digga.lib.importers.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [
              core
              starship
              cachix
              fonts
              users.root
              yubikey
              smartd
              us-keyboard
            ];
            graphical = base ++ [
              gnome
              sound
              psd
            ];
            personal-desktop =
              graphical ++
              [
                localization
                fuse
                podman
                xmonad
                users.akirakomamura
              ];
          };
        };
      };

      home = { };

      devshell.externalModules = { pkgs, ... }: {
        packages = [ pkgs.gnumake pkgs.nvfetcher ];
      };

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      defaultTemplate = self.templates.flk;
      templates.flk.path = ./.;
      templates.flk.description = "flk template";

    }
  ;
}
