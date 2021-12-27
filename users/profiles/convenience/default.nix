{ pkgs, ... }:
{
  home.packages = with pkgs; [
    du-dust
    duf
    glances
    xh
    fd
    ripgrep
    jq
    nvfetcher
    tealdeer
    pre-commit
  ];

  programs.bat.enable = true;

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}
