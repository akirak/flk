{
  programs.git = {
    enable = true;

    extraConfig = {
      pull.rebase = false;

      "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";

      core.autocrlf = "input";

      # Only on WSL
      # core.fileMode = false;

      # Increase the size of post buffers to prevent hung ups of git-push.
      # https://stackoverflow.com/questions/6842687/the-remote-end-hung-up-unexpectedly-while-git-cloning#6849424
      http.postBuffer = "524288000";
    };

    ignores = [
      ".direnv"
    ];

    signing.key = "5B3390B01C01D3E";
  };

  programs.gh.enable = true;
}
