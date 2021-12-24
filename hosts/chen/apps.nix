# Settings for specific apps used on the machine
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Maybe switch to tenacity soon?
    audacity
  ];
}
