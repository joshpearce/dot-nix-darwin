{ osConfig, config, lib, pkgs, ... }:
let 
  python312-with-pkgs = pkgs.python312.withPackages (p: with p; [

  ]);

in {
  home.packages = [
    python312-with-pkgs
  ];
}