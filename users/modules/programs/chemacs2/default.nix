{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.chemacs2;
  makePackage = name: value: pkgs.callPackage ./profile.nix (value // {
    inherit name;
    inherit (config.home) homeDirectory;
  });
in
{
  options = {
    programs.chemacs2 = {
      enable = mkEnableOption "Chemacs2";

      profiles = mkOption {
        type = types.attrsOf types.attrs;
        description = ''
          Configuration.
        '';
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    home.file.".emacs.d".source = pkgs.fetchFromGitHub {
      owner = "plexus";
      repo = "chemacs2";
      rev = "ef82118824fac2b2363d3171d26acbabe1738326";
      sha256 = "1gg4aa6dxc4k9d78j8mrrhy0mvhqmly7jxby69518xs9njxh00dq";
    };

    home.packages = mapAttrsToList makePackage cfg.profiles;
  };
}
