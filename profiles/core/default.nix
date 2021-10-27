{ self, config, lib, pkgs, ... }:
let inherit (lib) fileContents;
in
{
  nix.systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  environment = {

    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      dnsutils
      dosfstools
      gptfdisk
      cryptsetup
      iputils
      moreutils
      nmap
      pciutils
      usbutils
      utillinux
      whois
      unzip
    ];

    sessionVariables = {
      "TMPDIR" = "/tmp";
    };
  };

  nix = {

    gc = {
      dates = "2weeks";

      automatic = true;
    };

    optimise.automatic = false;

    useSandbox = true;

    allowedUsers = [ "@wheel" ];

    trustedUsers = [ "root" "@wheel" ];

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';

  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  services.earlyoom.enable = true;

}
