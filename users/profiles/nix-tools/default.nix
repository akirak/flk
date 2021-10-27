{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cachix
    nix-prefetch-git
    manix
    nix-index
  ];
}
