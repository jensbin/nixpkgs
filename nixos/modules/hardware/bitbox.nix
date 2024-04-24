{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.bitbox;
in

{
  options.hardware.bitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Bitbox devices.
      '';
    };

    package = mkPackageOption pkgs "bitbox" {
      extraDescription = ''
        This can be used to install a package with udev rules that differ from the defaults.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
  };
}
