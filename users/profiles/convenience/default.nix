{ pkgs, ... }:
{
  programs.bat.enable = true;

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };
}
