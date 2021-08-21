{ suites, pkgs, ... }:
{
  imports = suites.personal-desktop;

  networking.hostName = "chen";
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # This kernel module is needed if and only if unlock LUKS devices on boot
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # This is unnecessary since / is on tmpfs
  # boot.tmpOnTmpfs = true;

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

  # Boot
  services.xserver.videoDriver = "intel";

  # Networking
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  #  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.persistence."/persist" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
      # "/var/lib/acme"
    ];
    # files = [
    #   "/etc/machine-id"
    # ];
  };

  environment.systemPackages = with pkgs; [ clinfo ];

  # Decrypt LUKS storage on boot
  boot.initrd.luks.reusePassphrases = true;
  boot.initrd.luks.devices =
    {
      cryptdata = {
        device = "/dev/disk/by-uuid/400a1403-8fe8-4817-a4fb-b6ec7b0fd0d0";
        preLVM = true;
        allowDiscards = true;
      };
    };

  fileSystems."/" =
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["defaults" "size=3G" "mode=755"];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4436-C0E5";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    {
      device = "rpool/local/nix";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/persist" =
    {
      device = "rpool/safe/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/home" =
    {
      device = "rpool/safe/home";
      fsType = "zfs";
    };

  fileSystems."/public" =
    {
      device = "/dev/mapper/860qvo1t-public";
      fsType = "ext4";
      options = [ "relatime" "discard" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/6e1f6320-2dd3-45ad-8d83-e916dffc9f1d"; }];

  nix.maxJobs = pkgs.lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";

  hardware = {
    bluetooth = {
      enable = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
      ];
    };
  };

}
