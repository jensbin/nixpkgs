# Bitbox {#module-programs-bitbox}

Bitbox is a hardware wallet and second-factor authenticator.

The `bitbox` programs module may be installed by setting
`programs.bitbox` to `true` in a manner similar to
```nix
{
  programs.bitbox.enable = true;
}
```
and bundles the `bitbox` package (see [](#sec-bitbox-package)) along with the
hardware module (see [](#sec-bitbox-hardware-module)) which sets up the
necessary udev rules to access the device.

Enabling the bitbox module is pretty much the easiest way to get a
Bitbox device working on your system.

For more information, see <https://shiftcrypto.support/help/en-us/10-download-installation/192-how-to-install-the-appimage>.

## Package {#sec-bitbox-package}

The binaries are available through the `bitbox` package which could be installed
as follows:
```nix
{
  environment.systemPackages = [
    pkgs.bitbox
  ];
}
```

## Hardware {#sec-bitbox-hardware-module}

The bitbox hardware package enables the udev rules for Bitbox
devices and may be installed as follows:
```nix
{
  hardware.bitbox.enable = true;
}
```

In order to alter the udev rules, one may provide different values for the
`udevRule51`, `udevRule52`, `udevRule53` and `udevRule54` attributes by means
of overriding as follows:
```nix
{
  programs.bitbox = {
    enable = true;
    package = pkgs.bitbox.override {
      udevRule51 = "something else";
    };
  };
}
```
