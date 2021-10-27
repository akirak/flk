{ pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [
      (callPackage ./jetbrains-mono.nix {})
      merriweather
      lato
    ];

    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono NF" ];

      sansSerif = [ "Lato" ];

      serif = [ "Merriweather" ];
    };
  };
}
