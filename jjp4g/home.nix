{ pkgs, config, lib, ... }:

{
  home-manager = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    users.josh = { pkgs, ... }: {
        home.username = "josh";
        home.homeDirectory = "/Users/josh";
        home.stateVersion = "23.05";
    };
  };
}
