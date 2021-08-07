{ pkgs, ... }:
{
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      githubSupport = true;
      pulseSupport = true;
      iwSupport = true;
    };
    # config = {
    #   "bar/top" = {
    #     monitor = "\${env:MONITOR:HDMI2}";
    #     # inherit = "bar/main";
    #     tray-position = "right";
    #   };
    # };
    extraConfig = ''
      [module/xmonad]
      type = custom/script
      exec = ${pkgs.xmonad-log}/bin/xmonad-log
      tail = true
    '';
    config = ./polybar.ini;
    script = ''
      polybar top &
      polybar bottom &
    '';
  };
}
