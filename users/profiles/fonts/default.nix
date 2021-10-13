{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cascadia-code
    libre-baskerville
    (callPackage ./shippori-mincho.nix {})
  ];
}
