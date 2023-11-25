    globalNix = {
      nixpkgs,
      hostName,
      inputs,
    }: let
      lib = nixpkgs.lib;
    in {
      # Setup the registry such that the entries are pinned to the versions we pull in here.
      # That should help with reproducability of disjoint projects & with compile times, too.
      nix.registry =
        (lib.mapAttrs' (name: _v: lib.nameValuePair name {flake = inputs.${name};}) inputs)
        // {
          ${hostName}.flake = self;
          nixpkgs.flake = nixpkgs;
        };
      # Also set the nix path such that pinned versions of stuff are
      # available as nix channel names:
      environment.etc =
        lib.mapAttrs' (name: flake: {
          name = "nix/inputs/${name}";
          value.source = flake.outPath;
        })
        (inputs // {nixpkgs = nixpkgs;});
    };