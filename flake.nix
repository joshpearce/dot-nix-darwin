{
  description = "Darwin system flake";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #darwin.url = "github:lnl7/nix-darwin";
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    deploy-flake.url = "github:boinkor-net/deploy-flake";
    deploy-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-dagger = {
      url = "github:dagger/homebrew-tap";
      flake = false;
    };
    homebrew-mcptools = {
      url = "github:f/mcptools";
      flake = false;
    };
    homebrew-bun = {
      url = "github:oven-sh/homebrew-bun";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , home-manager
    , darwin
    , deploy-flake
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-bundle
    , homebrew-dagger
    , homebrew-mcptools
    , homebrew-bun
    , agenix
    } @ flakes:
    let
      system = "aarch64-darwin";
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      # Monitor this: https://github.com/nixos/nixpkgs/issues/461406
      overlay-fish-no-checks = final: prev: {
        fish = prev.fish.overrideAttrs (oldAttrs: {
          doCheck = false;
        });
      };
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      darwinConfigurations."JJP4G" = darwin.lib.darwinSystem {
        modules = [
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ overlay-stable overlay-fish-no-checks ];
          })
          ./jjp4g/default.nix
        ];
        specialArgs = { inherit flakes; inherit system; };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."JJP4G".pkgs;
    };
}
