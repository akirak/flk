{
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  #  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
}
