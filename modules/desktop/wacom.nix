{
  lib,
  config,
  ...
}: {
  options.enable = lib.mkOption {default = false;};
  config = lib.mkIf config.enable {
    hardware.opentabletdriver.enable = true;
    nixpkgs.config = {
      permittedInsecurePackages = [
        "dotnet-runtime-6.0.36"
        "dotnet-sdk-wrapped-6.0.428"
        "dotnet-sdk-6.0.428"
      ];
    };
  };
}
