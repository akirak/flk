{ makeWrapper
, runCommandNoCC
, symlinkJoin
, makeDesktopItem
, writeShellScriptBin
, runtimeShell
, lib
, emacs
, homeDirectory
, # Use 'nix run' instead of package
  useNixRun ? false
, # Name of the profile
  name
, # Emacs package
  package ? emacs
, # The value of user-emacs-directory
  directory
, # The value of custom-file (optional)
  customFile ? null
, # The name of the flake app starting with '#', if you use nix run
  appName ? ""
, # The app that runs emacsclient, if any
  clientAppName ? null
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
      (lib.mapAttrsToList
        (name: value:
          if value == null
          then ""
          else '' (${name} . "${value}") ''
        )
        profileAttrs)
    + ")";

  normalDerivation = runCommandNoCC "emacs-profile-${name}"
    {
      preferLocalBuild = true;
      nativeBuildInputs = [
        makeWrapper
      ];
      propagatedBuildInputs =
        if useNixRun
        then [ ]
        else [ package ];
    } ''
    mkdir -p $out/bin
    makeWrapper ${package}/bin/emacs $out/bin/emacs-${name} \
      --add-flags "--with-profile '${profileArg}'"
    makeWrapper ${package}/bin/emacsclient $out/bin/emacsclient-${name} \
      --add-flags "-s ${name}"
  '';

  indirectCallDerivation = symlinkJoin {
    name = "emacs-profile-${name}-run";
    preferLocalBuild = true;
    paths = [
      (writeShellScriptBin "emacs-${name}" ''
        exec nix run --no-update-lock-file "${expandTilde directory}${appName}" \
          -- --with-profile '${profileArg}' "$@"
      '')
    ] ++ (lib.optional (clientAppName != null)
      (writeShellScriptBin "emacsclient-${name}"
        ''
          exec nix run --no-update-lock-file "${expandTilde directory}${clientAppName}" \
            -- --with-profile '${profileArg}' "$@"
        ''));
  };

  drv =
    if useNixRun
    then indirectCallDerivation
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
