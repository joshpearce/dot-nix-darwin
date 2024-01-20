{ pkgs, flakes, ... }:

{

  imports =
    [ 
      flakes.home-manager.darwinModules.home-manager
    ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.josh = { pkgs, ... }: {
      imports = [
        
      ];
      home.username = "josh";
      home.homeDirectory = "/Users/josh";
      home.stateVersion = "23.05";
      home.packages = with pkgs; [ 
        git-crypt
        speedtest-cli
        
      ];
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
