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
      home.packages = with pkgs; [ 
        git-crypt
        speedtest-cli
        flakes.deploy-flake.packages.${system}.deploy-flake
        pkgs.stable.magic-wormhole
        # tailscale
        cmatrix
        miniserve
        iperf2
        #spek
        dotnet-sdk_8
        #pulseview
        jq
        yt-dlp
        ipatool
        lazygit
        kubectl
        fluxcd
        ripgrep
        yq-go
        kubernetes-helm
        fq
        texliveTeTeX
        #ollama  # Temporarily disabled due to build failure
        wireshark
      ];
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.git = {
        enable = true;
        settings = {
          user.name = "Josh Pearce";
          user.email = "joshua.pearce@gmail.com";
          credential.cacheOptions = "--timeout 30";
          init.defaultBranch = "main";
          alias = {
            up = ''!if x="$(git rev-parse --is-inside-work-tree 2>/dev/null)"; then git remote update -p; if [ "$x" = true ]; then git merge --ff-only @{u}; else echo >&2 'git-up: not updating work tree in bare repo'; fi; else echo >&2 'git-up: not inside a git repo'; false; fi; #'';
          };
        };

      };

      home.file.".zprofile".source = ./dot_files/.zprofile;
      home.file.".zshrc".source = ./dot_files/.zshrc;
      home.file.".aws/config".source = ./dot_files/.aws/config;
    };
  };
}
