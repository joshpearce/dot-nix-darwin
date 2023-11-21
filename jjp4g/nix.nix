{ flakes, pkgs, ... }: {
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 90d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}