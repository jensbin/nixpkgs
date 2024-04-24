{ appimageTools, lib, fetchurl
, udevRule51 ? ''
  SUBSYSTEM=="usb", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbb%n", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
  ''
, udevRule52 ? ''
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbbf%n"
  ''
, udevRule53 ? ''
  SUBSYSTEM=="usb", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="bitbox02_%n", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403"
  ''
, udevRule54 ? ''
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="bitbox02_%n"
  ''
, writeText
}:
let
  pname = "BitBox";
  version = "4.42.0";
  name = "${pname}-${version}";

  # https://bitbox.swiss/download/#checksums
  src = fetchurl {
    url = "https://github.com/digitalbitbox/bitbox-wallet-app/releases/download/v${version}/${name}-x86_64.AppImage";
    sha256 = "b3aaecfa80c94c2390619a16daf193dd3064588c2fb2feef7a56e0799abe7c38";
  };

  copyUdevRuleToOutput = name: rule:
    "cp ${writeText name rule} $out/etc/udev/rules.d/${name}";

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/bitbox.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/bitbox.png $out/share/icons/hicolor/128x128/apps/bitbox.png

    # Provide udev rules as documented in https://shiftcrypto.support/help/en-us/9-troubleshooting/15-usb-connection-issues-my-bitbox02-is-not-detected
    mkdir -p "$out/etc/udev/rules.d"
    ${copyUdevRuleToOutput "51-hid-digitalbox.rules" udevRule51}
    ${copyUdevRuleToOutput "52-hid-digitalbox.rules" udevRule52}
    ${copyUdevRuleToOutput "53-hid-bitbox02.rules" udevRule53}
    ${copyUdevRuleToOutput "54-hid-bitbox02.rules" udevRule54}
  '';

  # services.udev.packages = [ pkgs.bitbox ];
  meta = with lib; {
    homepage = "https://bitbox.swiss/app";
    changelog = "https://bitbox.swiss/blog/tag/release";
    description = "The BitBoxApp for desktop and mobile";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ vidbina jensbin ];
    platforms = [ "x86_64-linux" ];
  };
}
