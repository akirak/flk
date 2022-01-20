{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # TODO: Add a package for the gnome extension
    # enableGnomeExtensions = true;
  };

  programs.chromium = {
    enable = false;
    package = pkgs.ungoogled-chromium;
  };
}
