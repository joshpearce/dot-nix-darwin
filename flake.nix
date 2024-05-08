{
  description = "Darwin system flake";

  inputs = {
    nixpkgs-jjp.url = "github:joshpearce/nixpkgs/rtl-433-update-rtl-sdr";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    deploy-flake.url = "github:boinkor-net/deploy-flake";
    deploy-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , nixpkgs-jjp
    , home-manager
    , darwin
    , deploy-flake
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    } @ flakes:
    let
      system = "aarch64-darwin";
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      overlay-jjp = final: prev: {
        jjp = import nixpkgs-jjp {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      darwinConfigurations."JJP4G" = darwin.lib.darwinSystem {

        #system = "${system}";
        modules = [
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ overlay-stable overlay-jjp ];
          })
          ./jjp4g/default.nix
        ];
        specialArgs = { inherit flakes; inherit system; };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."JJP4G".pkgs;
    };
}
