{ pkgs, ...}:
{
  networking.networkmanager = {
    enable = true;
    packages = [
      pkgs.networkmanagerapplet
    ];
  };

  services.xserver = {
    xkbOptions = "ctrl:nocaps";
    enableCtrlAltBackspace = true;
    libinput = {
      enable = true;
      mouse = {
        disableWhileTyping = true;
      };
    };
    # startDbusSession = true;
  };

  services.dbus = {
    enable = true;
    # socketActivated = true;
    packages = [ pkgs.gnome3.dconf ];
  };

  services.gnome3.gnome-keyring.enable = true;

  services.blueman.enable = true;
}
