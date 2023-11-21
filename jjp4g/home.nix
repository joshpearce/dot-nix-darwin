{ pkgs, config, lib, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.josh = { pkgs, ... }: {
        home.username = "josh";
        home.homeDirectory = "/Users/josh";
        home.stateVersion = "23.05";
    };
  };
}
