{ suites, pkgs, ... }:
{
  imports = suites.personal-desktop ++ [
    ../../profiles/zfs-pools/rpool
    ./non-zfs-system-ssd.nix
    ./networking.nix
    ./intel-video.nix
    ./apps.nix
    ../../profiles/development
  ];

  networking.hostName = "chen";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # This kernel module is needed if and only if unlock LUKS devices on boot
  # boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.runSize = "64m";
  boot.devSize = "256m";
  boot.devShmSize = "256m";

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  # Configure ARC up to 4 GiB
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ];
  # Needed for the ZFS pool.
  networking.hostId = "1450b997";

  # Maintenance
  services.journald = {
    extraConfig = ''
      SystemMaxFiles=5
    '';
  };

  # Other hardware-specific settings
  nix.maxJobs = pkgs.lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";
  hardware.bluetooth = {
    enable = true;
  };
}
