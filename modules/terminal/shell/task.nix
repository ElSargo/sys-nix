{ pkgs, ... }:
let
  src = pkgs.fetchurl {
    url =
      "https://raw.githubusercontent.com/nushell/nu_scripts/66aa80064ea3c62af52695c9f00de6f45f575068/modules/background_task/task.nu";
    sha256 = "4+ngaJnoyO9qZLAT+OfcwmW+7+qZMLxRi71TxBXGq1s=";
  };
  cu = x: "${pkgs.coreutils}/bin/${x}";
  cp = cu "cp";
  mkdir = cu "mkdir";
  module = derivation {
    # system = builtins.currentSystem;
    system = "x86_64-linux";
    builder = "${pkgs.bash}/bin/bash";
    args = [
      "-c"
      ''
        ${mkdir} -p $out/
        ${cp} ${src} $out/task.nu
      ''
    ];
    name = "task";
  };

in
{
  home.packages = [ pkgs.pueue ];
  wayland.windowManager.hyprland.extraConfig = "${pkgs.pueue}/bin/pueued -d";
  programs.nushell.extraConfig = "use ${module}/task.nu";
}
