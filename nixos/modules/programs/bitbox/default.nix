{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.bitbox;
in

{
  options.programs.bitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Installs the Bitbox application and enables the complementary hardware module.
      '';
    };

    package = mkPackageOption pkgs "bitbox" {
      extraDescription = ''
        This can be used to install a package with udev rules that differ from the defaults.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    hardware.bitbox = {
      enable = true;
      package = cfg.package;
    };
  };

  meta = {
    doc = ./default.md;
    maintainers = with lib.maintainers; [ jensbin vidbina ];
  };
}
