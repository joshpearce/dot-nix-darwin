{ flakes, pkgs, ... }: {
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 90d";
    };
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
  };

  nixpkgs.config.allowUnfree = true;
}