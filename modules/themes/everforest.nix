{
  config,
  pkgs,
  ...
}: {
  config.theme = config.mkTheme "everforest.yaml";
  config.wallpaper = pkgs.fetchUrl {
    url = "https://unsplash.com/photos/Rfflri94rs8/download?ixid=M3wxMjA3fDB8MXxhbGx8MTIxfHx8fHx8Mnx8MTcxMTk1Mjc4NXw&force=true";
  };
}
