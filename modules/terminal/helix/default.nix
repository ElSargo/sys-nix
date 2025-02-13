{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    helix-package = lib.mkOption {
      default = pkgs.unstable.helix;
      type = lib.types.package;
    };
  };

  config = {
    home.packages = with pkgs.unstable; [nil markdown-oxide taplo rust-analyzer rustfmt clippy];
    xdg.configFile."helix/config.toml".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/home/sargo/sys-nix/modules/terminal/helix/config.toml");
    programs.helix = {
      enable = true;
      package = config.helix-package;
    };
  };
}
