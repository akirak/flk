{
  makeWrapper,
  runCommandNoCC,
  symlinkJoin,
  makeDesktopItem,
  writeShellScriptBin,
  runtimeShell,
  lib,
  emacs,
  homeDirectory,
  # Use 'nix run' instead of package
  useNixRun ? false,
  # Name of the profile
  name,
  # Emacs package
  package ? emacs,
  # The value of user-emacs-directory
  directory,
  # The value of custom-file (optional)
  customFile ? null
}:
let
  expandTilde = str:
    if lib.hasPrefix "~/" str
    then homeDirectory + "/" + lib.removePrefix "~/" str
    else str;

  profileAttrs = {
    user-emacs-directory = directory;
    server-name = name;
    custom-file = customFile;
  };

  profileArg =
    "(" +
    lib.concatStrings
    (lib.mapAttrsToList (name: value:
      if value == null
      then ""
      else '' (${name} . "${value}") ''
    ) profileAttrs)
    + ")";

  normalDerivation = runCommandNoCC "emacs-profile-${name}" {
    preferLocalBuild = true;
    nativeBuildInputs = [
      makeWrapper
    ];
    propagatedBuildInputs =
      if useNixRun
      then []
      else [ package ];
  } ''
      mkdir -p $out/bin
      makeWrapper ${package}/bin/emacs $out/bin/emacs-${name} \
        --add-flags "--with-profile '${profileArg}'"
      makeWrapper ${package}/bin/emacsclient $out/bin/emacsclient-${name} \
        --add-flags "-s ${name}"
  '';

  indirectCall = writeShellScriptBin "emacs-${name}" ''
    exec nix run --no-update-lock-file "${expandTilde directory}" -- --with-profile '${profileArg}' "$@"
  '';

  drv = if useNixRun
        then indirectCall
        else normalDerivation;

in
symlinkJoin {
  name = "emacs-profile-${name}";
  preferLocalBuild = true;
  paths = [
    drv
    (makeDesktopItem {
      name = "Emacs Profile ${name}";
      type = "Application";
      exec = "${drv}/bin/emacs-${name}";
      desktopName = "emacs-${name}";
      terminal = false;
    })
  ];
}
