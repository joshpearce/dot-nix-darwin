{ flakes, pkgs, ... }: {
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      dates = "08:15";
      options = "--delete-older-than 90d";
    };
    optimise = {
      automatic = true;
      dates = ["08:45"];
    };
  };

  nixpkgs.config.allowUnfree = true;
}