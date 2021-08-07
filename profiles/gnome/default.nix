{
  imports = [
    ../gdm
  ];

  services.xserver.desktopManager.gnome3 = {
    enable = true;
  };

  services.gnome3 = {
    chrome-gnome-shell.enable = true;
  };
}
