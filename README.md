First time:
nix --extra-experimental-features flakes --extra-experimental-features nix-command run nix-darwin -- switch --flake ~/.config/nix-darwin

Subsequent times:
darwin-rebuild switch --flake ~/.config/nix-darwin
or
darwin-rebuild build --flake .#JJP4G 

Where is stuff installed?
ls /run/current-system/sw/bin/

Original zsh configs are in:
/System/Library/Templates/Data/private/etc