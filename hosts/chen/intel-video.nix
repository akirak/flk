{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.clinfo ];

  services.xserver = {
    videoDrivers = [
      "modesetting"
    ];
    useGlamor = true;
    xrandrHeads = [
      {
        output = "HDMI1";
        monitorConfig = ''
          Option "Primary" "true"
          Option "Mode" "2560x1440"
          Option "Position" "0 0"
        '';
      }
      {
        output = "HDMI2";
        monitorConfig = ''
          Option "Mode" "1920x1080"
          Option "Position" "2560 0"
        '';
      }

    ];
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
