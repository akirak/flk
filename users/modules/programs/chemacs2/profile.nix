{ makeWrapper
, runCommandNoCC
, symlinkJoin
, makeDesktopItem
, writeShellScriptBin
, writeShellScript
, runtimeShell
, lib
, emacs
, homeDirectory
  # Whether to add a suffix to executables
, suffixExecutables ? true
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
# Clone this repository to the user emacs directory
, origin ? null
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

  absoluteDirectory = expandTilde directory;

  executableSuffix = if suffixExecutables then "-${name}" else "";

  ensureConfigCommand =
    if origin == null
    then ""
    else ''
      pwd="$PWD"
      if [[ -d "${absoluteDirectory}" ]]; then
        cd "${absoluteDirectory}"
        realOrigin="$(git config --get --local remote.origin.url)"
        if ! [[ "$realOrigin"  = ${origin} ]]; then
          cat <<MSG >&2
      The origin of $PWD does not match:
        Expected: ${origin}
        Actual: $realOrigin
      MSG
          exit 1
        fi
      else
        mkdir -p "$(dirname "${absoluteDirectory}")"
        git clone --recurse-submodules "${origin}" "${absoluteDirectory}"
      fi
      cd "$pwd"
    '';

  ensureCommandAsDerivation = writeShellScript "ensure-emacs-profile-${name}" ensureConfigCommand;

  normalDerivation = runCommandNoCC "emacs-profile-${name}"
    {
      preferLocalBuild = true;
      nativeBuildInputs = [ makeWrapper ];
      propagatedBuildInputs = [ package ];
    } ''
    mkdir -p $out/bin
    makeWrapper ${package}/bin/emacs $out/bin/emacs${executableSuffix} \
      ${if origin != null then "--run ${ensureCommandAsDerivation}" else ""} \
      --add-flags "--with-profile '${profileArg}'"
    makeWrapper ${package}/bin/emacsclient $out/bin/emacsclient${executableSuffix} \
      ${if origin != null then "--run ${ensureCommandAsDerivation}" else ""} \
      --add-flags "-s ${name}"
  '';

  indirectCallDerivation = symlinkJoin {
    name = "emacs-profile-${name}-run";
    preferLocalBuild = true;
    paths = [
      (writeShellScriptBin "emacs${executableSuffix}" ''
        ${ensureConfigCommand}
        exec nix run --no-update-lock-file "${expandTilde directory}${appName}" \
          -- --with-profile '${profileArg}' "$@"
      '')
    ] ++ (lib.optional (clientAppName != null)
      (writeShellScriptBin "emacsclient${executableSuffix}"
        ''
          ${ensureConfigCommand}
          exec nix run --no-update-lock-file "${expandTilde directory}${clientAppName}" \
            -- -s ${name} "$@"
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
      exec = "${drv}/bin/emacs${executableSuffix}";
      desktopName = "emacs-${name}";
      terminal = false;
    })
  ];
}
