{ pkgs, self, flakes, ... }:
{

  imports =
    [
      ./nix.nix
      ./users.nix
      ./home.nix
    ];


  environment = {
    systemPackages = with pkgs; [
      nixpkgs-fmt
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
