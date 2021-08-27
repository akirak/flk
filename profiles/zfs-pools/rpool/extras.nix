{

  fileSystems."/git-annex/personal" =
    {
      device = "rpool/git-annex/personal";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/git-annex/hobbies" =
    {
      device = "rpool/git-annex/hobbies";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/assets/archives/personal/git" =
    {
      device = "rpool/git/archives";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/assets/archives/hoard/git" =
    {
      device = "rpool/git/hoard";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/assets/work" =
    {
      device = "rpool/git/work";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/assets/archives/personal/appdata" =
    {
      device = "rpool/media/appdata";
      fsType = "zfs";
      options = [ "noatime" ];
    };

  fileSystems."/assets/archives/hoard/media" =
    {
      device = "rpool/media/hoard";
      fsType = "zfs";
      options = [ "noatime" ];
    };

}
