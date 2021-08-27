{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Necessary if you want to turn on allowOther in impermanence
  # https://github.com/nix-community/impermanence
  # programs.fuse.userAllowOther = true;
}
