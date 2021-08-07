{
  imports = [
    ../wm-helpers
  ];

  services.xserver.displayManager = {
    defaultSession = "xmonad";
    session = [
      {
        manage = "desktop";
        name = "xmonad";
        start = ''
          exec $HOME/.xsession
        '';
      }
    ];
  };
}
