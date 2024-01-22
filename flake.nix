{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin"; # newest version as of may 2023, probably needs to get updated in november
    home-manager.url = "github:nix-community/home-manager/release-23.05"; # ...
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    deploy-flake.url = "github:boinkor-net/deploy-flake";
    deploy-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    , deploy-flake
    } @ flakes:
    let
      darwinSystem = "aarch64-darwin";
    in
    {
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
      darwinConfigurations."JJP4G" = darwin.lib.darwinSystem {

        system = "${darwinSystem}";
        modules = [
          ({
            system.configurationRevision =
              if self ? rev
              then self.rev
              else "DIRTY";
          })
          ./jjp4g/default.nix
        ];
        specialArgs = { inherit flakes; system = darwinSystem; };
      };

      # Expose the package set, including overlays, for convenience.
      # darwinPackages = self.darwinConfigurations."JJP4G".pkgs;
    };
}
