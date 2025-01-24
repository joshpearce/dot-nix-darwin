{ config, pkgs, self, flakes, ... }:

{

  imports =
    [
      ./nix.nix
      ./users.nix
      ./home.nix
      flakes.nix-homebrew.darwinModules.nix-homebrew
      ./userLaunchAgents
      flakes.agenix.darwinModules.default
      ../secrets/jjp4g.nix
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
      "stlink"
      "libiconv"
      "hidapi"
      "r"
      "opentofu"
      "tflint"
      "terraform"
      "go"
      "age"
      "python3"
    ];
    casks = [
      "1password"
      "1password-cli"
      "balenaetcher"
      "calibre"
      "firefox"
      "kdiff3"
      "secretive"
      "wireshark"
      "pgadmin4"
      "tor-browser"
      "sqlitestudio"
      "qflipper"
      "gqrx"
      "mqtt-explorer"
      "moonlight"
      "inkscape"
      "dbeaver-community"
      "openscad"
      "vlc"
      "rstudio"
      "insomnia"
      "google-cloud-sdk"
      "zoom"
    ];
    masApps = {
      "tailscale" = 1475387142;
      "discovery_dns_sd_browser" = 1381004916;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      nixpkgs-fmt
      mas
      awscli2
      pkgs.aws-vault # dep xdg-user-dirs-0.18 was not available on aarch64-apple-darwin
      yubikey-manager
      pkgs.jjp.rtl_433
      iperf
      runitor
      flakes.agenix.packages.aarch64-darwin.default
    ];
    extraSetup = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  fileSystems."/Volumes/Calibre" = {
    device = "//nas.jjpdev.com/calibre";
    fsType = "smbfs";
    options = [ "credentials=${config.age.secrets.calibre-smb-credentials.path}" "rw" ];
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
