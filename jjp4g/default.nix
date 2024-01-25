{ pkgs, self, flakes, ... }:

{

  imports =
    [
      ./nix.nix
      ./users.nix
      ./home.nix
      flakes.nix-homebrew.darwinModules.nix-homebrew
    ];

  users = {
    knownUsers = [
      "brew"
    ];
    users = {
      brew = {
        gid = 12;
        uid = 510;
        isHidden = true;
        home = "/opt/homebrew/";
        createHome = true;
        description = "Homebrew";
        shell = "/usr/bin/false";
      };
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "brew";
    taps = {
      "homebrew/homebrew-core" = flakes.homebrew-core;
      "homebrew/homebrew-cask" = flakes.homebrew-cask;
    };
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    brews = [
      "hugo"
    ];
    casks = [
      "1password"
      "1password-cli"
      "balenaetcher"
      "calibre"
      "firefox"
      "kdiff3"
      "secretive"
    ];
    masApps = {
      "tailscale" = 1475387142;
      "discovery_dns_sd_browser" = 1381004916;
    };
  };

  environment = {
    systemPackages = with pkgs.unstable; [
      nixpkgs-fmt
      python312
      mas
      awscli2
      aws-vault
      yubikey-manager
    ];
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
  # removed /etc/zshrc and /etc/zprofile, let nix create them, and added:
  # sudo ln -s /System/Library/Templates/Data/private/etc/zshrc /etc/zshrc.local
  # sudo ln -s /System/Library/Templates/Data/private/etc/zprofile /etc/zprofile.local

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

}
