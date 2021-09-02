{ pkgs, ... }:
{
  programs.chemacs2 = {
    enable = true;
    profiles = {
      default = {
        # package = pkgs.emacs;
        useNixRun = true;
        clientAppName = "#emacsclient";
        directory = "~/.config/emacs";
        customFile = "~/.local/share/emacs/custom.el";
        origin = "https://github.com/akirak/emacs.d.git";
      };
    };
  };
}
