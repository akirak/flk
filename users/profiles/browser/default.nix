{ pkgs, ... }:
{
  home.packages = [
    pkgs.nyxt
  ];

  programs.firefox = {
    enable = true;
    # TODO: Add a package for the gnome extension
    # enableGnomeExtensions = true;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
}
