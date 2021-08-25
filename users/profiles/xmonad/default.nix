{pkgs, ...}:
{
  imports = [
    ./lock.nix
    ./dunst.nix
    ./picom.nix
    ./polybar
  ];

  home.packages = with pkgs; [
    arandr
    pavucontrol
    pasystray
    dunst # for dunstctl
    xmonad-log
  ];

  xsession = {
    enable = true;

    initExtra = ''
      pasystray &
      blueman-applet &
      nm-applet --sm-disable --indicator &
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = h: [
        h.dbus
      ];
      config = ./xmonad.hs;
    };

  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
}
