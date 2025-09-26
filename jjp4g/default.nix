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
      "homebrew/homebrew-bundle" = flakes.homebrew-bundle;
      "dagger/homebrew-tap" = flakes.homebrew-dagger;
      "f/mcptools" = flakes.homebrew-mcptools;
    };
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps; # https://github.com/zhaofengli/nix-homebrew/issues/5
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
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
      "podman"
      "skopeo"
      "flyctl"
      "gh"
      "probe-rs-tools"
      "ffmpeg"
      "node"
      "esptool"
      "uv"
      "libgit2"
      "imagemagick"
      "socat"
      "tokei"
      "gnu-tar"
      "pandoc"
      "pkg-config"
      "mcp"
      "poetry"
    ];
    casks = [
      "1password"
      "1password-cli"
      "balenaetcher"
      "calibre"
      "firefox"
      "kdiff3"
      "secretive"
      "pgadmin4"
      "tor-browser"
      "sqlitestudio"
      "qflipper"
      "gqrx"
      "mqtt-explorer"
      "inkscape"
      "dbeaver-community"
      "openscad"
      "vlc"
      "rstudio"
      "insomnia"
      "zoom"
      "texmaker"
      "kicad"
      "visual-studio-code"
      "positron"
      "block-goose"
      "utm"
      "context"
      "gcloud-cli"
      "container-use"
      "container"
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
      #pkgs.rtl_433
      iperf
      flakes.agenix.packages.aarch64-darwin.default
    ];
    extraSetup = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  programs.zsh.enable = true;
  # removed /etc/zshrc and /etc/zprofile, let nix create them, and added:
  # sudo ln -s /System/Library/Templates/Data/private/etc/zshrc /etc/zshrc.local
  # sudo ln -s /System/Library/Templates/Data/private/etc/zprofile /etc/zprofile.local

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.primaryUser = "josh";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

}
