{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
