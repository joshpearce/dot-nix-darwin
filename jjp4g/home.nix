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
        home.username = "josh";
        home.homeDirectory = "/Users/josh";
        home.stateVersion = "23.05";
        home.packages = with pkgs; [ 
          git-crypt
        ];
    };
  };
}
