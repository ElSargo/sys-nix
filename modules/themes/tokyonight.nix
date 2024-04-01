{
  config,
  pkgs,
  ...
}: {
  config.theme = config.mkTheme "tokyo-night-terminal-storm";
  config.wallpaper = pkgs.fetchUrl {
    url = "https://unsplash.com/photos/P-yzuyWFEIk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTV8fHNjZW5lcnl8ZW58MHx8fHwxNzExOTQ4MDk4fDA&force=true";
  };
}
