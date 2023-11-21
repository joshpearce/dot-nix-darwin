{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin"; # newest version as of may 2023, probably needs to get updated in november
    home-manager.url = "github:nix-community/home-manager/release-23.05"; # ...
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, 
              nixpkgs,
              home-manager,
              darwin
            } @ flakes:
  let
    
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."JJP4G" = darwin.lib.darwinSystem {
      
      system = "aarch64-darwin";
      modules = [ 
        ({
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;
        })
        home-manager.darwinModules.home-manager
        ./jjp4g/default.nix 
      ];
      specialArgs = { inherit flakes; };
    };

    # Expose the package set, including overlays, for convenience.
    # darwinPackages = self.darwinConfigurations."JJP4G".pkgs;
  };
}
