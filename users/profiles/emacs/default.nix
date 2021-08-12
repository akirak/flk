{ pkgs, ... }:
{
  programs.chemacs2 = {
    enable = true;
    profiles = {
      default = {
        # package = pkgs.emacs;
        useNixRun = true;
        directory = "~/.config/emacs";
        customFile = "~/local/emacs/custom.el";
      };
    };
  };
}
