{ ... }:
{
  users.users.akirakomamura = {
    uid = 1000;
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ];
    hashedPassword = "$6$4UhguaItTVfvZm0$0UTUCTHVtxM8I7.gfBD/mJaXYmHGkqWSYf6.q6P49VS7FmKWIjdUlFPuuc9Ap57.p5299xZ/T33zb/3o3T317.";
  };

  home-manager.users.akirakomamura = { suites, ... }: {
    imports = suites.development;
  };

  security.sudo.wheelNeedsPassword = false;

}
