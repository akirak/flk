{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cascadia-code
    (callPackage ./shippori-mincho.nix {})
  ];
}
