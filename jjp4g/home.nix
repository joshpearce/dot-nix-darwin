{ 
  pkgs, 
  flakes, 
  system,
  ... 
}:

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
      home.packages = with pkgs.unstable; [ 
        vscode
        git-crypt
        speedtest-cli
        flakes.deploy-flake.packages.${system}.deploy-flake
        magic-wormhole
      ];
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.git = {
        enable = true;
        userName = "Josh Pearce";
        userEmail = "joshua.pearce@gmail.com";
        extraConfig = {
          credential.cacheOptions = "--timeout 30";
          init.defaultBranch = "main";
        };

      };

      home.file.".zprofile".source = ./dot_files/.zprofile;
      home.file.".zshrc".source = ./dot_files/.zshrc;
      home.file.".aws/config".source = ./dot_files/.aws/config;
    };
  };
}
