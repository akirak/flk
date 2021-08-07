{ self, config, lib, pkgs, ... }:
# Based on instructions from https://christine.website/blog/paranoid-nixos-2021-07-18
{
  networking.firewall.enable = true;
  # services.tailscale.enable = true;
  # networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
